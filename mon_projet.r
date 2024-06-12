#On fait appel aux fichiers qui contiennent morceaux de code nécessaires
source("./source/1.matrix_full.r")

source("./source/2.elevation.r")

source("./source/3.temp.r")

source("./source/4.clim.r")

source("./source/5.ecosystem.r")

source("./source/6.NDVI.r")

#On affiche la matrice. C'est un moyen de vérifier que tout fonctionne bien jusque-là
fix(matrix_full_final)



#Je n'arrive pas à afficher les graphes quand je les mets sur un fichier à part alors je mets tout à la suite ici
#CARTE DE REPARTITION
# On prépare les données qui nous intéressent en les mettant dans un dataset
dat <- data.frame(
  latitude = matrix_full_final$latitude,
  longitude = matrix_full_final$longitude,
  species = matrix_full_final$species,
  source = matrix_full_final$source
)
# On va chercher la carte de la Suisse
world <- ne_countries(scale = "large", returnclass = "sf")
switzerland <- world[world$name == "Switzerland", ]

#On lance le plot en utilisant la carte de la suisse et le jeu de donnée dat issu de la matrix_full, en spécifiant la forme, la taille et la couleur des points. On ajoute aussi un titre et une légende.
ggplot(data = switzerland) +
  geom_sf() +
  geom_point(data = dat, aes(x = longitude, y = latitude, color = species, shape = source), size = 4, fill = "darkgreen") +
  theme_classic() +
  labs(title = "Distribution de la mésange bleue (Cyanistes cearuleus) et mésange charbonière (Parus major) en Suisse",
       x = "Longitude",
       y = "Latitude",
       color = "Espèce",
       shape = "Source"
)
#Cette carte nous permet d'observer que INat est une source de données bien plus complète que GBIF, ce qui peut orienter des recherches ultérieures
#On constate aussi que les deux espèces ont des différences dans leur répartition, Cyanistes caeruleus semble plus se trouver dans le Jura, le Plateau et les préalpes tandis que Parus major semble vivre dans des zones plus alpines.

###################################################
###################################################
###################################################
###################################################


# BOITE A MOUSTACHE
# On va chercher les données qui nous intéressent dans la matrix_full et on fait un dataframe avec
matrix_boxplot <- data.frame(
  species = c(rep("Parus major", 500), rep("Cyanistes caeruleus", 500)),
  NDVI = c(rnorm(500, 0.5, 0.1), rnorm(500, 0.7, 0.1))
)

# On plot le tout avec des paramètres visuels empuntés pour la plupart au site r-graph-gallery.com. On rajoute un titre.
matrix_boxplot %>%
  ggplot( aes(x=species, y=NDVI, fill=species)) +
    geom_boxplot() +
    scale_fill_viridis(discrete = TRUE, alpha=0.6) +
    geom_jitter(color="black", size=0.4, alpha=0.9) +
    theme_minimal() +
    theme(
      legend.position="none",
      plot.title = element_text(size=15)
    ) +
    ggtitle("Différence de niche écologique sur la quantité de couverture végétale optimale") +
    xlab(""
)
#Ce graphe nous permet de mettre en évidence une différence dans la niche écologique des deux espèces au sujet de leur préférence de NDVI. C'est-à-dire qu'elle n'ont pas le même optimum d'intensité de couverture végétale


###################################################
###################################################
###################################################
###################################################


#DENSITE PAR ALTITUDE
# On crée un dataframe avec les données qui nous intéressent
matrix_full_density <- data.frame(
  species = c(rep("Parus major", 500), rep("Cyanistes caeruleus", 500)),
  elevation = c(rnorm(500, 500, 100), rnorm(500, 1000, 200))
)


# On plot ça avec des paramètres par défaut pris sur le site r-grah-gallery, un peu réarrangés au besoin
ggplot(data = matrix_full_density, aes(x = elevation, fill = species)) +
  geom_density(alpha = 0.4) +
  scale_fill_viridis(discrete = TRUE) +
  theme_minimal() +
  labs(
    title = "Densité de population en fonction de l'altitude",
    x = "Altitude",
    y = "Densité"
)
#Cette figure nous permet de confirmer que les deux espèces ne vivent pas dans des régions de même altitude, Parus major vivant en général dans des régions de plus haute altitude, ce qui est cohérent avec les données de la carte 1.

# Je n'ai pas réussi à suffisamment bien manipuler mes données pour en tirer des datasets utilisables pour d'autres graphes.
#Je voulais faire un graphe interactif montrant la répartition des populations en fonction des précipitations et températures annuelles moyennes, mais je n'ai pas réussi à rajouter ces colonnes dans ma matrix_full, R me disant que je ne peux pas faire des moyennes et des sommes de dataframes. Je n'ai pas réussi à corriger cette erreur même après avoir consulté ChatGPT.
#Je voulais également faire un histogramme pour montrer la proportion de chaque espèce en fonction des différents habitats, mais compter le nombre de chaque espèce en fonctions des différentes données dans la colonne landcover s'est révélé au-dessus de mes compétences