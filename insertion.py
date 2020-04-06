from random import randint
from datetime import datetime
import random
import shutil
import os



def getNomMale():
    f = open("src/male-names.txt", "r")

    fName = f.read().splitlines()

    idP = randint(0, 1951)
    idN = randint(1952, 3899)

    prenom = fName[idP]
    nom = fName[idN]

    sortie = [nom, prenom]
    return sortie


def getNomFemale():
    f = open("src/female-names.txt", "r")

    fName = f.read().splitlines()

    idP = randint(0, 2477)
    idN = randint(2478, 4954)

    prenom = fName[idP]
    nom = fName[idN]

    sortie = [nom, prenom]
    return sortie


def getPays():
    f = open("src/pays.txt", "r")

    fPays = f.read().splitlines()

    idP = randint(0, 83)
    pays = fPays[idP]

    return pays


def getDateNaissance():
    year = random.choice(range(1982, 2001))
    month = random.choice(range(1, 13))
    day = random.choice(range(1, 29))
    birth_date = datetime(year, month, day)

    return str(birth_date.strftime("%Y-%m-%d"))


def getSexe():
    tab = ['M', 'F']
    r = random.choice(tab)
    return r


def getRandomId(min, max):
    return str(randint(min, max))


def getRandomDuree(min, max):
    d = random.uniform(min, max)
    return str(round(d, 3))


def insertInto_ATHLETES( ):
    sexe = getSexe()


    if sexe == 'M':
        nom_prenom = getNomMale()
    else:
        nom_prenom = getNomFemale()

    requette = "INSERT INTO ATHLETES (NOM, PRENOM, DATE_NAISSANCE, SEXE, PAYS, STATUS) VALUES ( '" + nom_prenom[0] + "' " \
                + ", '" + nom_prenom[1] + "' , '" + getDateNaissance() + "' , '" + sexe + "' , '" + getPays() + "' , 0 );"


    return requette


def randomOther():
    tab = []

    for i in range(1, 54):
        if i not in [1, 5, 21, 36, 37, 38, 39, 40, 41, 42, 43]:
            tab.append(i)

    return tab


def getDateSubEpreuve():
    year = 2018
    month = 8
    day = random.choice(range(3, 32))
    date_sub_epreuve = datetime(year, month, day)

    return str(date_sub_epreuve.strftime("%Y-%m-%d"))


def insertInto_RESULTATS_ATHLETE(nom_sub_epreuve, i, j):
    if nom_sub_epreuve == "MARATHON M":
        requette = "INSERT INTO RESULTATS_ATHLETE(ID_ATHLETE, ID_JEU_OLYMPIQUE, ID_SUB_EPREUVE, RANG, DUREE, DATE_)" \
                   + " VALUES ( " + str(i) + " , " + str(25) + " , " + str(5) + " , " + getRandomId(1,
                                                                                                    4) + " , " + getRandomDuree(
            7500, 10000) + " , " + "'2016-08-12' );"

    elif nom_sub_epreuve == "200M_NAGE_LIBRE":
        requette = "INSERT INTO RESULTATS_ATHLETE(ID_ATHLETE, ID_JEU_OLYMPIQUE, ID_SUB_EPREUVE, RANG, DUREE, DATE_)" \
                   + " VALUES ( " + str(i) + " , " + str(25) + " , " + str(21) + " , " + getRandomId(1,
                                                                                                     4) + " , " + getRandomDuree(
            100, 110) + " , " + "'2016-08-18' );"

    elif nom_sub_epreuve == "100M M":
        requette = "INSERT INTO RESULTATS_ATHLETE(ID_ATHLETE, ID_JEU_OLYMPIQUE, ID_SUB_EPREUVE, RANG, DUREE, DATE_)" \
                   + " VALUES ( " + str(i) + " , " + str(25) + " , " + str(1) + " , " + getRandomId(1,
                                                                                                    4) + " , " + getRandomDuree(
            9.8, 11) + " , " + "'2016-08-7' );"

    else:
        requette = "INSERT INTO RESULTATS_ATHLETE(ID_ATHLETE, ID_JEU_OLYMPIQUE, ID_SUB_EPREUVE, RANG, DUREE, DATE_)" \
                   + " VALUES ( " + str(i) + " , " + str(25) + " , " + str(j) + " , " + getRandomId(1,
                                                                                                    4) + " , " + getRandomDuree(
            9.8, 11) + " , " + "'" + getDateSubEpreuve() + "' );"

    return requette




def generateCompose():
    fichier = open('tmp/INSERTION_COMPOSE.sql', 'w')

    fichier.write("\n")
    fichier.write("\echo 'INSERTION_COMPOSE'")
    fichier.write("\n")

    SUB_EPREUVES = [i for i in range(1, 54)]
    requettes = []  # la listes de toutes les requettes

    for j in SUB_EPREUVES:
        requette = "INSERT INTO COMPOSE(ID_JEU_OLYMPIQUE, ID_SUB_EPREUVE)" \
                   + " VALUES ( " + str(31) + " , " + str(j) + ");"

        fichier.write(requette + "\n")
        requettes.append(requette)

    fichier.close()

    return requettes


def generateATHLETES():
    fichier = open("tmp/INSERTION_ATHLETES.sql", "w")
    fichier.write("\n")
    fichier.write("\echo 'INSERTION_ATHLETES'")
    fichier.write("\n")
    i = 0

    while i < 1080:
        donnee = insertInto_ATHLETES()

        fichier.write(donnee + "\n")
        i += 1

    fichier.write("\n")
    fichier.close()


def generateAthletesEnEquipe():
    tab1 = ['United States', 'Spain', 'Argentina', 'Italy']
    tab2 = ['France', 'Brasil', 'Korea South', 'United Kingdom']

    requettes = []
    fichier = open("tmp/INSERTION_ATHLETES_BIS.sql", "w")



    i = 1081

    j = 0
    cpt, cpt2, cpt3 = 0, 0, 0

    while (i < 1173):
        if i < 1125 and i >= 1081:
            nom_prenom = getNomMale()
            requette = "INSERT INTO ATHLETES (NOM, PRENOM, DATE_NAISSANCE, SEXE, PAYS, STATUS) VALUES ( '" + nom_prenom[
                0] + "' " \
                       + ", '" + nom_prenom[1] + "' , '" + getDateNaissance() + "' , '" + "M" + "' , '" + tab1[
                           j] + "' , 1 );"
            fichier.write(requette + "\n")
            cpt += 1
            if cpt % 11 == 0:
                j += 1
                if j == 4:
                    j = 0

                fichier.write("\n")
            requettes.append(requette)




        elif i < 1149 and i >= 1025:

            nom_prenom = getNomMale()
            requette = "INSERT INTO ATHLETES (NOM, PRENOM, DATE_NAISSANCE, SEXE, PAYS, STATUS) VALUES ( '" + nom_prenom[
                0] + "' " \
                       + ", '" + nom_prenom[1] + "' , '" + getDateNaissance() + "' , '" + "M" + "' , '" + tab2[
                           j] + "' , 1 );"
            fichier.write(requette + "\n")

            cpt2 += 1
            if cpt2 % 6 == 0:
                j += 1

                if j == 4:
                    j = 0

                fichier.write("\n")

            requettes.append(requette)


        elif i < 1173 and i >= 1149:

            nom_prenom = getNomFemale()
            requette = "INSERT INTO ATHLETES (NOM, PRENOM, DATE_NAISSANCE, SEXE, PAYS, STATUS) VALUES ( '" + nom_prenom[
                0] + "' " \
                       + ", '" + nom_prenom[1] + "' , '" + getDateNaissance() + "' , '" + "F" + "' , '" + tab2[
                           j] + "' , 1 );"
            fichier.write(requette + "\n")
            cpt3 += 1
            if cpt3 % 6 == 0:
                j += 1

                if j == 4:
                    j = 0
                fichier.write("\n")

            requettes.append(requette)

        i += 1

    fichier.close()


def generateResultatAthlete():
    fichier = open("tmp/INSERTION_RESULTAT_ATHLETES.sql", "w")

    fichier.write("\n")
    fichier.write("\echo 'INSERTION_RESULTAT_ATHLETES'")
    fichier.write("\n")

    n = 1
    tab = randomOther()
    j = 0
    while n <= 1080:

        if n < 24:
            donnee = insertInto_RESULTATS_ATHLETE("MARATHON M", n, 0)
            fichier.write(donnee + "\n")

        elif (n >= 24) and (n < 49):
            donnee = insertInto_RESULTATS_ATHLETE("200M_NAGE_LIBRE", n, 0)
            fichier.write(donnee + "\n")

        elif (n >= 49) and (n < 73):
            donnee = insertInto_RESULTATS_ATHLETE("100M M", n, 0)
            fichier.write(donnee + "\n")


        elif (n >= 73):
            donnee = insertInto_RESULTATS_ATHLETE("other", n, tab[j])
            fichier.write(donnee + "\n")
            if ((n % 24) == 0):
                j += 1


        n += 1

    fichier.close()


def generateResultatAthEnEquipe():
    requettes = []
    fichier = open("tmp/INSERTION_RESULTAT_ATHLETES_BIS.sql", "w")
    i = 1081

    j = 0
    cpt, cpt2, cpt3 = 0, 0, 0

    while (i < 1173):
        if i < 1125 and i >= 1081:
            nom_prenom = getNomMale()
            requette = "INSERT INTO RESULTATS_ATHLETE(ID_ATHLETE, ID_JEU_OLYMPIQUE, ID_SUB_EPREUVE, RANG, DUREE, DATE_)" \
                       + " VALUES ( " + str(i) + " , " + str(25) + " , " + str(38) + " , " + str(j + 1) + \
                       " , " + str(5400) + " , " + "'2016-08-13'" + " );"

            fichier.write(requette + "\n")
            cpt += 1
            if cpt % 11 == 0:
                j += 1
                if j == 4:
                    j = 0


            requettes.append(requette)




        elif i < 1149 and i >= 1025:

            nom_prenom = getNomMale()
            requette = "INSERT INTO RESULTATS_ATHLETE(ID_ATHLETE, ID_JEU_OLYMPIQUE, ID_SUB_EPREUVE, RANG, DUREE, DATE_)" \
                       + " VALUES ( " + str(i) + " , " + str(25) + " , " + str(40) + " , " + str(j + 1) + \
                       " , " + str(3600) + " , " + "'2016-08-14'" + " );"
            fichier.write(requette + "\n")

            cpt2 += 1
            if cpt2 % 6 == 0:
                j += 1

                if j == 4:
                    j = 0

                fichier.write("\n")

            requettes.append(requette)


        elif i < 1173 and i >= 1149:

            nom_prenom = getNomFemale()
            requette = "INSERT INTO RESULTATS_ATHLETE(ID_ATHLETE, ID_JEU_OLYMPIQUE, ID_SUB_EPREUVE, RANG, DUREE, DATE_)" \
                       + " VALUES ( " + str(i) + " , " + str(25) + " , " + str(41) + " , " + str(j + 1) + \
                       " , " + str(5400) + " , " + "'2016-08-21'" + " );"
            fichier.write(requette + "\n")
            cpt3 += 1
            if cpt3 % 6 == 0:
                j += 1

                if j == 4:
                    j = 0
                fichier.write("\n")

            requettes.append(requette)

        i += 1

    fichier.close()


def generateMembres():
    requettes = []
    fichier = open("tmp/INSERTION_MEMBRES.sql", "w")

    fichier.write("\n")
    fichier.write("\echo 'INSERTION_MEMBRES'")
    fichier.write("\n")

    i = 1081

    j = 1
    cpt, cpt2, cpt3 = 0, 0, 0

    while (i < 1173):
        if i < 1125 and i >= 1081:

            requette = "INSERT INTO MEMBRES(ID_ATHLETE, ID_EQUIPE,ANNEE)" \
                       + " VALUES ( " + str(i) + " , " + str(j) + " , " + str(2016) + " );"

            fichier.write(requette + "\n")
            cpt += 1
            if cpt % 11 == 0:
                j += 1

                fichier.write("\n")
            requettes.append(requette)




        elif i < 11049 and i >= 1025:

            requette = "INSERT INTO MEMBRES(ID_ATHLETE, ID_EQUIPE,ANNEE)" \
                       + " VALUES ( " + str(i) + " , " + str(j) + " , " + str(2016) + " );"

            fichier.write(requette + "\n")

            cpt2 += 1
            if cpt2 % 6 == 0:
                j += 1

                fichier.write("\n")

            requettes.append(requette)


        elif i < 1173 and i >= 1049:

            requette = "INSERT INTO MEMBRES(ID_ATHLETE, ID_EQUIPE,ANNEE)" \
                       + " VALUES ( " + str(i) + " , " + str(j) + " , " + str(2016) + " );"

            fichier.write(requette + "\n")
            cpt3 += 1
            if cpt3 % 6 == 0:
                j += 1

                fichier.write("\n")

            requettes.append(requette)

        i += 1

    fichier.close()


def generateResultatEquipes():
    requettes = []
    fichier = open("tmp/INSERTION_RESULTAT_EQUIPES.sql", "w")

    fichier.write("\n")
    fichier.write("\echo 'INSERTION_RESULTAT_EQUIPES'")
    fichier.write("\n")

    i = 1

    j = 1
    cpt, cpt2, cpt3 = 1, 1, 1

    while (i < 13):
        if i < 5 and i >= 1:

            requette = "INSERT INTO RESULTATS_EQUIPE(ID_EQUIPE, ID_JEU_OLYMPIQUE, ID_SUB_EPREUVE, RANG, SCORE, DATE_)" \
                       + " VALUES ( " + str(i) + " , " + str(31) + " , " + str(38) + " , " + str(
                j) + " , " + "'3-1'" + " , " + "'2016-08-18'" + " );"
            j += 1
            fichier.write(requette + "\n")

            fichier.write("\n")
            requettes.append(requette)




        elif i < 9 and i >= 5:

            requette = "INSERT INTO RESULTATS_EQUIPE(ID_EQUIPE, ID_JEU_OLYMPIQUE, ID_SUB_EPREUVE, RANG, SCORE, DATE_)" \
                       + " VALUES ( " + str(i) + " , " + str(31) + " , " + str(40) + " , " + str(
                cpt2) + " , " + "'30-26'" + " , " + "'2016-08-19'" + " );"

            fichier.write(requette + "\n")

            cpt2 += 1

            fichier.write("\n")

            requettes.append(requette)


        elif i < 13 and i >= 9:

            requette = "INSERT INTO RESULTATS_EQUIPE(ID_EQUIPE, ID_JEU_OLYMPIQUE, ID_SUB_EPREUVE, RANG, SCORE, DATE_)" \
                       + " VALUES ( " + str(i) + " , " + str(31) + " , " + str(41) + " , " + str(
                cpt3) + " , " + "'23-25'" + " , " + "'2016-08-20'" + " );"

            fichier.write(requette + "\n")
            cpt3 += 1

            fichier.write("\n")

            requettes.append(requette)

        i += 1

    fichier.close()


def genrateMichaelPhelps():

    fichier=open("tmp/INSERTION_PHELPS.sql","w")

    requette = "INSERT INTO ATHLETES (NOM, PRENOM, DATE_NAISSANCE, SEXE, PAYS) VALUES ('Michael'," \
               "'Phelps','1985-06-30','M','United States');"
    fichier.write(requette+"\n")


    j=9
    for i in range(18,22):
        dateEp="'2018-08-"+str(j)+"'"
        requette = "INSERT INTO RESULTATS_ATHLETE(ID_ATHLETE, ID_JEU_OLYMPIQUE, ID_SUB_EPREUVE, RANG, DUREE, DATE_)" \
                + " VALUES ( " + str(1173) + " , " + str(25) + " , " + str(i) + " , " + str(1)+ " , "+getRandomDuree(8.23,9.75)+\
                 " , "+dateEp+");"
        fichier.write(requette + "\n")

        j+=1

    fichier.close()


def generateAll():

    if not os.path.exists("tmp"):
        os.makedirs("tmp")

    generateCompose()
    generateATHLETES()
    generateAthletesEnEquipe()
    generateResultatAthlete()
    generateResultatAthEnEquipe()
    generateMembres()
    generateResultatEquipes()
    genrateMichaelPhelps()

    fichier_final = open("sql/INSERTIONS.sql", "w")

    list_fichier=['src/INSERTION_MANUELLE.sql','INSERTION_COMPOSE.sql','INSERTION_ATHLETES.sql'
                  ,'INSERTION_ATHLETES_BIS.sql','INSERTION_RESULTAT_ATHLETES.sql'
                  ,'INSERTION_RESULTAT_ATHLETES_BIS.sql','INSERTION_MEMBRES.sql'
                  ,'INSERTION_RESULTAT_EQUIPES.sql','INSERTION_PHELPS.sql']

    for i in list_fichier:
        if i=='src/INSERTION_MANUELLE.sql':
            shutil.copyfileobj(open(i, 'r'), fichier_final)
        else:
            shutil.copyfileobj(open("tmp/"+i, 'r'), fichier_final)

    shutil.rmtree("tmp")

    fichier_final.close()






generateAll()
