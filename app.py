import streamlit as st
import sqlite3
import pandas as pd
from datetime import datetime

# Configuration de la page mobile
st.set_page_config(page_title="Alpha Fitness", page_icon="💪", layout="centered")

ADMIN_PASSWORD = "admin123"
MODES_PAIEMENT = ["Espèces", "Carte Bancaire", "Chèque", "Prélèvement"]
FORMULES = {
    "Séance 10": [0, 10.0], "Séance 20": [0, 20.0], 
    "Mensuel 60": [1, 60.0], "Mensuel 50": [1, 50.0],
    "Trimestriel 140": [3, 140.0], "Trimestriel 130": [3, 130.0],
    "Semestriel 230": [6, 230.0], "Semestriel 220": [6, 220.0],
    "Annuel": [12, 450.0]
}

# Connexion à la base de données
conn = sqlite3.connect("gestion_salle_web.db", check_same_thread=False)
cursor = conn.cursor()
cursor.execute("""
    CREATE TABLE IF NOT EXISTS adherents (
        id TEXT PRIMARY KEY, nom TEXT, prenom TEXT, telephone TEXT, 
        date_debut TEXT, formule TEXT, prix REAL, date_fin TEXT, mode_paiement TEXT
    )
""")
conn.commit()

def calculer_date_fin(d_obj, f_nom):
    m_add = FORMULES[f_nom][0]
    if m_add == 0: return d_obj.strftime("%Y-%m-%d")
    ans = d_obj.year + (d_obj.month + m_add - 1) // 12
    mois = (d_obj.month + m_add - 1) % 12 + 1
    jour = min(d_obj.day, [31, 29 if ans%4==0 and (ans%100!=0 or ans%400==0) else 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][mois-1])
    return datetime(ans, mois, jour).strftime("%Y-%m-%d")

# Barre latérale de navigation pour le téléphone
menu = st.sidebar.radio("Navigation", ["📥 Inscription", "🔑 Espace Admin"])

if menu == "📥 Inscription":
    st.header("Fiche d'Inscription")
    with st.form("form_inscription", clear_on_submit=True):
        i_id = st.text_input("ID Adhérent *")
        i_nom = st.text_input("Nom *")
        i_pr = st.text_input("Prénom *")
        i_tel = st.text_input("Téléphone")
        i_dt = st.date_input("Date Début", datetime.now())
        f_val = st.selectbox("Formule *", list(FORMULES.keys()))
        p_val = st.selectbox("Mode de Règlement *", MODES_PAIEMENT)
        
        submit = st.form_submit_button("💾 ENREGISTRER L'ADHÉRENT")
        
        if submit:
            if not (i_id and i_nom and i_pr):
                st.error("Veuillez remplir les champs obligatoires.")
            else:
                prix = FORMULES[f_val][1]
                df = calculer_date_fin(i_dt, f_val)
                try:
                    cursor.execute("INSERT INTO adherents VALUES (?,?,?,?,?,?,?,?,?)", 
                                   (i_id, i_nom, i_pr, i_tel, i_dt.strftime("%Y-%m-%d"), f_val, prix, df, p_val))
                    conn.commit()
                    st.success(f"Adhérent {i_nom.upper()} enregistré avec succès !")
                    
                    st.info(f"""
                    **📄 REÇU D'INSCRIPTION - ALPHA FITNESS**
                    * **ID Membre** : {i_id}
                    * **Nom Complet** : {i_nom.upper()} {i_pr}
                    * **Formule** : {f_val} ({prix:.2f} Tnd)
                    * **Valide jusqu'au** : {df}
                    * **Règlement** : {p_val}
                    """)
                except Exception as e:
                    st.error("Cet ID existe déjà dans la base de données.")

elif menu == "🔑 Espace Admin":
    st.header("Espace Administrateur")
    pwd = st.text_input("Entrez le mot de passe :", type="password")
    
    if pwd == ADMIN_PASSWORD:
        tab1, tab2 = st.tabs(["👥 Liste des Membres", "📈 Chiffre d'Affaires"])
        
        with tab1:
            st.subheader("Recherche & Filtrage")
            df_adherents = pd.read_sql_query("SELECT * FROM adherents", conn)
            
            if not df_adherents.empty:
                search = st.text_input("Rechercher par Nom ou ID :").strip().lower()
                if search:
                    df_adherents = df_adherents[df_adherents['nom'].str.lower().str.contains(search) | df_adherents['id'].str.lower().str.contains(search)]
                
                aujourdhui = datetime.now().date()
                status_list = []
                for idx, row in df_adherents.iterrows():
                    try:
                        date_fin = datetime.strptime(row['date_fin'], "%Y-%m-%d").date()
                        delta = (date_fin - aujourdhui).days
                        if delta < 0: status_list.append("❌ Expiré")
                        elif delta <= 15: status_list.append("⚠️ Attention (<15j)")
                        else: status_list.append("✅ Actif")
                    except: status_list.append("Inconnu")
                
                df_adherents['Statut'] = status_list
                st.dataframe(df_adherents, use_container_width=True)
                
                # Option de suppression simplifiée en tapant l'ID
                st.subheader("🗑️ Zone de Suppression")
                del_id = st.text_input("Entrez l'ID de l'adhérent à supprimer :")
                if st.button("Supprimer définitivement"):
                    if del_id:
                        cursor.execute("DELETE FROM adherents WHERE id=?", (del_id,))
                        conn.commit()
                        st.success(f"Adhérent ID {del_id} supprimé. Veuillez rafraîchir la page.")
            else:
                st.write("Aucun adhérent enregistré pour le moment.")
                
        with tab2:
            st.subheader("Statistiques Financières")
            df_finances = pd.read_sql_query("SELECT prix, date_debut, mode_paiement FROM adherents", conn)
            if not df_finances.empty:
                total_ca = df_finances['prix'].sum()
                st.metric(label="Chiffre d'Affaires Total", value=f"{total_ca:.2f} Tnd")
                
                st.write("**Ventilation par Mode de Paiement :**")
                df_pay = df_finances.groupby('mode_paiement')['prix'].sum().reset_index()
                for idx, row in df_pay.iterrows():
                    st.write(f"🔹 {row['mode_paiement']} : {row['prix']:.2f} Tnd")
            else:
                st.write("Aucune transaction enregistrée.")
