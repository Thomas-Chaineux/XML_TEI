<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace = "http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <xsl:output method="html" indent="yes"/>
    <!--PLAN GENERAL:
        - Une page d'accueil avec un maximum de données introductives
        - Une page avec l'édition du quotidien Temps (1872)
        - Une page avec l'édition en livre de Hertzel et Cie (1873)
        - Une page avec une édition comparée des deux précédentes
        - Une page de statistiques sur les mentions et dialogues des personnages-->
    
    
    <!-- 1. DECLARATION DES VARIABLES 
                1.1 Variables de noms de fichiers HTML-->
    <!--1.1.1 déclaration de la variable de la page d'acceuil-->
    <xsl:variable name="accueil">
        <xsl:value-of select="concat('accueil','.html')"/>
    </xsl:variable>
    
    <!--1.1.2 déclaration de la variable de la page d'édition du Tour du Monde dans le journal Le Temps (1872)-->    
    <xsl:variable name="edTemps">
        <xsl:value-of select="concat('edition_du_temps','.html')"/>
    </xsl:variable>
    
    <!--1.1.3 déclaration de la variable de la page d'edition en livre par les Editions Hetzel (1873)-->    
    <xsl:variable name="edHetzel">
        <xsl:value-of select="concat('edition_hetzel','.html')"/>
    </xsl:variable>
    
    <!--1.1.4 déclaration de la variable de la page d'edition comparée des deux précédentes-->    
    <xsl:variable name="edComparee">
        <xsl:value-of select="concat('edition_comparee','.html')"/>
    </xsl:variable>
    
    <!--1.1.5 déclaration de la variable de la page de statistiques-->    
    <xsl:variable name="statistiques">
        <xsl:value-of select="concat('statistiques','.html')"/>
    </xsl:variable>

    
    
                <!-- 1.2 Variables des éléments constitutifs d'un fichier HTML -->
    <!--1.2.1 Déclaration d'une variable contenant le HEAD des pages HTML -->
    <xsl:variable name="head">
        <head>          
            <title>Le tour du monde en quatre-vingts jours</title>
            <meta name="description" content="Le tour du monde en quatre_vingts jours par Jules Verne"/>
            <meta name="author" content="Thomas Chaineux"/>
            <link rel="icon" href="https://www.chartes.psl.eu/favicon.ico"/>
            <link rel="stylesheet" type="text/css" href="style.css"/> 
        </head>
    </xsl:variable>    
   
    <!--1.2.2 Déclaration d'une variable contenant le HEADER du body de chaque page, avec le titre et le menu de navigation -->
    <xsl:variable name="header">
        <header>
            <h1 title="main">Le Tour du Monde en quatre-vingts jours</h1> 
            <h2 title="subtitle">par Jules Verne. Chapitre <xsl:value-of select="//body//head[@type='num']"/></h2>
            <ul>
                <li><a href="{$statistiques}">Statistiques</a></li>
                <li><a href="{$edComparee}">Edition comparée</a></li>
                <li><a href="{$edHetzel}">Edition Hertzel &amp; Cie</a></li>       
                <li><a href="{$edTemps}">Edition du Temps</a></li>
                <li><a href="{$accueil}">Accueil</a></li>                
            </ul>
        </header>    
    </xsl:variable>   
    
    <!-- 1.2.3 Declaration d'une variable contenant l'EN-TÊTE des deux pages d'édition de texte -->
    <xsl:variable name="en_tete">
        <div>
            <xsl:attribute name="class">center</xsl:attribute>
            <xsl:attribute name="title">num</xsl:attribute>
            CHAPITRE <xsl:value-of select="//body//head[@type='num']"/>
        </div><br/>
        <div>
            <xsl:attribute name="class">center</xsl:attribute>
            <xsl:attribute name="title">sous_titre</xsl:attribute>
            <xsl:value-of select="//body//head[@type='soustitre']"/>
        </div>  
    </xsl:variable>    
    
    <!--1.2.4 Déclaration d'une variable contenant le FOOTER de toutes les pages HTML -->
    <xsl:variable name="footer">
        <footer>
            <p><xsl:value-of select="//respStmt/resp"/><xsl:text>, et édition en HTML pour le cours de Transformation XSLT de Jean-Damien Généro</xsl:text></p>
        </footer>
    </xsl:variable>
    
    
    
  
    
    
    <!-- 2. TEMPLATES et REGLES DE TRANSFORMATION XSLT-->
    
    <xsl:template match="/"><!--template général sur la racine-->
        <xsl:call-template name="accueil"/><!-- appel du template de la page d'accueil -->
        <xsl:call-template name="edTemps"/><!-- appel du template de l'edition du Temps -->
        <xsl:call-template name="edHetzel"/><!-- appel du template de l'édition de Hetzel -->
        <xsl:call-template name="edComparee"/><!-- appel du template de l'édition comparées des deux versions -->
        <xsl:call-template name="statistiques"/><!-- appel du template de la page de statistiques -->
    </xsl:template>
    
    
    <!-- TEMPLATE DE LA PAGE D'ACCUEIL -->
    <!-- L'encodage TEI utilisait beaucoup de référentiels externes type wikidata; nous les reproduisont ici -->
    <xsl:template name="accueil">
        <xsl:result-document href="{$accueil}" method="html">
            <html lang="fr">
                <xsl:copy-of select="$head"/>
                <body>
                    <xsl:copy-of select="$header"/>
                    <main><!-- le main est divisés en plusieurs parties: introduction (texte de présentation), sources (liens vers Gallica), choix d'encodage (texte tiré de la TEI), personnages rencontrés et lieux traversés -->
                        
                        <!-- INTRO -->
                        <div title="edition">Accueil</div>
                        <div title="titre_intro">Introduction</div>
                        <p>Ce projet consiste en une édition du chapitre <xsl:value-of select="//body//head[@type='num']"/> du roman <i><xsl:value-of select="//fileDesc/titleStmt/title"/></i> de <xsl:value-of select="concat(//fileDesc/titleStmt/author/forename,' ', //fileDesc/titleStmt/author/surname)"/>. 
                            Celui-ci a été publié une première fois dans les colonnes du journal 
                            <a>
                                <xsl:attribute name="href"><xsl:value-of select="//witness[@xml:id='feuilleton']//publisher/@ref"/></xsl:attribute>
                                <xsl:value-of select="//witness[@xml:id='feuilleton']//publisher/name"/>
                            </a>  le <xsl:value-of select="//fileDesc/publicationStmt/date[@when-iso]"/>, avant une première publication en format livre l'année suivante par l'éditeur 
                            <a>
                                <xsl:attribute name="href"><xsl:value-of select="//witness[@xml:id='hetzel']//publisher/@ref"/></xsl:attribute>
                                <xsl:value-of select="//witness[@xml:id='hetzel']//publisher/name"/>
                            </a>. La présente édition numérique a pour objectif de présenter ces deux versions et, dans la mesure où elles comportent quelques différences, de présenter une édition comparée et des statistiques relatives aux personnages.</p> 
                        
                        
                        <!-- SOURCES -->
                        <div title="titre_intro">Sources</div>
                        <p>Les versions témoins sont consultables aux liens ci-dessous:</p>
                        <ol>
                            <li>
                                <a><xsl:attribute name="href"><xsl:value-of select="//witness[@xml:id='feuilleton']//distributor/@facs"/></xsl:attribute>
                                    <xsl:value-of select="//witness[@xml:id='feuilleton']//publisher/name"/>                                    
                                </a>
                            </li>
                            <li>
                                <a>
                                    <xsl:attribute name="href"><xsl:value-of select="//witness[@xml:id='hetzel']//distributor/@facs"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="//witness[@xml:id='hetzel']//publisher/name"/>                                    
                                </a>
                            </li>
                        </ol>
                        <p>Les conditions de reproduction des documents issus de Gallica sont disponibles 
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="//fileDesc/publicationStmt//licence/@target"/>
                                </xsl:attribute> à cette adresse.
                            </a>                                         
                        </p>
                        
                        
                        <!-- CHOIX d'ENCODAGE -->
                        <div title="titre_intro">Encodage</div>
                        <p>
                            <xsl:value-of select="//editorialDecl/p"/>
                        </p>
                        <ol>
                            <li><xsl:value-of select="//hyphenation"/></li>
                            <li><xsl:value-of select="//normalization"/></li>
                        </ol>
                        
                        
                        
                        <!-- LISTE DES PERSONNAGES -->
                        <div title="titre_intro">Présentation des personnages</div>
                        <ol>
                            <xsl:for-each select="//particDesc//person"><!--Concaténation des éléments de noms des personnages, et lien wikidata si renseigné-->
                                <div class="card">
                                    <xsl:for-each select=".">
                                        <xsl:choose>
                                            <xsl:when test=".//forename">
                                                <h4>
                                                    <a>
                                                        <xsl:attribute name="href"><xsl:value-of select="./persName/@ref"/></xsl:attribute>
                                                        <xsl:value-of select="concat(.//forename, ' ', .//surname)"/>
                                                    </a>
                                                </h4>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <h4>
                                                    <xsl:value-of select=".//persName"/>
                                                </h4>
                                            </xsl:otherwise>
                                        </xsl:choose> 
                                    </xsl:for-each>
                                    
                                    <p><b>Sexe: </b> <xsl:value-of select="./sex"/></p><!-- Mention du sexe du personnage -->
                                    
                                    <p><b>Nationalité: </b> <xsl:value-of select="./nationality"/></p><!-- Mention de la nationalité du personnage -->
                                    
                                    <xsl:choose><!-- Mention du lieu de résidence du personnage, affiché différement si une ville est mentionnée ou non  -->
                                        <xsl:when test="./residence/settlement">
                                            <p><b>Résidence: </b>
                                                <xsl:value-of select="./residence/settlement"/>
                                                <xsl:text> (</xsl:text>
                                                <xsl:value-of select="./residence/country"/>
                                                <xsl:text>)</xsl:text></p>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <p><b>Résidence: </b>
                                                <xsl:value-of select="./residence/country"/></p>
                                        </xsl:otherwise>
                                        
                                    </xsl:choose>
                                    <xsl:if test="./socecStatus"><!-- Mention du statut social du personnage (si renseigné)-->
                                        <p><b>Statut social: </b> <xsl:value-of select="./socecStatus"/></p>  
                                    </xsl:if>
                                    
                                    <xsl:if test="./occupation"><!-- Mention de la profession du personnage (si renseignée)-->
                                        <p><b>Profession: </b> <xsl:value-of select="./occupation"/></p>  
                                    </xsl:if>
                                    
                                    <p><xsl:value-of select="./note"/></p><!-- Reprise du texte présentant le personnage -->
                                </div>
                            </xsl:for-each>
                        </ol>
                        
                        
                        <!-- LIEUX RENCONTRES -->
                        <div title="titre_intro">Liste des lieux rencontrés</div>
                        <ol>
                            <xsl:for-each select="//settingDesc//place">
                                <div class="card">
                                    <xsl:for-each select=".">
                                        <h4>
                                            <xsl:choose><!-- Mention du nom du lieu, avec lien wikidata si existant -->
                                                <xsl:when test="./placeName/@ref">
                                                    <a>
                                                        <xsl:attribute name="href"><xsl:value-of select="./placeName/@ref"/></xsl:attribute>
                                                        <xsl:value-of select="./placeName"/>
                                                    </a>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="./placeName"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </h4>
                                    </xsl:for-each>
                                    
                                    <p><b>Type de lieu: </b><!-- Mention du type du lieu, selon qu'il s'agisse d'une région, d'une ville ou d'un édifice -->
                                        <xsl:choose>
                                            <xsl:when test=".[@type='region']">
                                                <xsl:text>région</xsl:text>
                                            </xsl:when>
                                            <xsl:when test=".[@type='city']">
                                                <xsl:text>ville</xsl:text>
                                            </xsl:when>
                                            <xsl:when test=".[@type='building']">
                                                <xsl:text>édifice</xsl:text>
                                            </xsl:when>
                                        </xsl:choose></p>
                                    
                                    <p><b>Pays (actuel): </b><!-- Mention du pays actuel du lieu-->
                                        <xsl:value-of select="./country"/></p>
                                    
                                    <xsl:if test="./region"><!-- Mention de la région à laquelle appartien le lieu (si renseignée)-->
                                        <p><b>Région: </b><xsl:value-of select="./region"/></p>
                                    </xsl:if>
                                    
                                    <xsl:if test="./population"><!-- Mention de la population constituante du lieu (si renseignée)-->
                                        <p><b>Population: </b><xsl:value-of select="./population"/></p>
                                    </xsl:if>
                                    
                                    <p><xsl:value-of select="./note"/></p></div><!-- Reprise du texte présentant le lieu -->
                            </xsl:for-each>
                        </ol>
                    </main>
                    <xsl:copy-of select="$footer"/>
                </body>
            </html>
        </xsl:result-document>        
    </xsl:template>
    
    
    
    
    
    <!-- TEMPLATE DE LA PAGE DE L'EDITION DU TEMPS. Les modes permettent de traiter les différentes versions du texte -->    
    <xsl:template name="edTemps">
        <xsl:result-document href="{$edTemps}" method="html">
            <html lang="fr">
                <xsl:copy-of select="$head"/>
                <body>                    
                    <xsl:copy-of select="$header"/>
                    <main>                  
                        <div title="edition">Edition du journal <i>Le Temps</i>, 16 novembre 1872</div>
                        <xsl:copy-of select="$en_tete"></xsl:copy-of>
                        <xsl:apply-templates select="//body//p" mode="temps"/>      
                    </main>                      
                    <xsl:copy-of select="$footer"/> 
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="//body//p" mode="temps">
        <p><xsl:apply-templates select="." mode="temps2"/></p>
    </xsl:template>
    
    <xsl:template match="//body//p//app" mode="temps2">
        <xsl:value-of select="./lem"/>
    </xsl:template>

    
    
    
    <!-- TEMPLATE DE LA PAGE DE L'EDITION HETZEL -->    
    <xsl:template name="edHetzel">
        <xsl:result-document href="{$edHetzel}" method="html">
            <html lang="fr">
                <xsl:copy-of select="$head"/>
                <body>                    
                    <xsl:copy-of select="$header"/>
                    <main>    
                        <div title="edition">Edition livre des ed. Hertzel, 1873</div>
                        <xsl:copy-of select="$en_tete"/>
                        <xsl:apply-templates select="//body//p" mode="hetzel"/>    
                    </main>                                
                    <xsl:copy-of select="$footer"/> 
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="//body//p" mode="hetzel">
        <p><xsl:apply-templates select="." mode="hetzel2"/></p>
    </xsl:template>
    
    <xsl:template match="//body//p//app" mode="hetzel2">
        <xsl:value-of select="./rdg"/>
    </xsl:template>
  
  
    <!-- TEMPLATE DE LA PAGE D'EDITION COMPAREE -->    
    <xsl:template name="edComparee">
        <xsl:result-document href="{$edComparee}" method="html">
            <html lang="fr">
                <xsl:copy-of select="$head"/>
                <body>                    
                    <xsl:copy-of select="$header"/>
                    <main>
                        <div title="edition">Edition comparée des deux premières versions publiées</div>
                        <xsl:copy-of select="$en_tete"></xsl:copy-of>
                        <xsl:apply-templates select="//body//p" mode="comparee"/>
                    </main>                                
                    <xsl:copy-of select="$footer"/> 
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="//body//p" mode="comparee">
        <p><xsl:apply-templates select="." mode="comparee2"/></p>
    </xsl:template>
    
    <xsl:template match="//body//p//app" mode="comparee2">
            (<b><xsl:text>Ed. du Temps: </xsl:text></b><i><xsl:value-of select="./lem"/></i>; 
            <b><xsl:text>Ed. Hertzel: </xsl:text></b><i><xsl:value-of select="./rdg"/></i>)        
    </xsl:template>



<!-- TEMPLATE DE LA PAGE DE STATISTIQUES-->
    <xsl:template name="statistiques">
        <xsl:result-document href="{$statistiques}" method="html">
            <html lang="fr">
                <xsl:copy-of select="$head"/>
                <body>                    
                    <xsl:copy-of select="$header"/>
                    <main type="container">
                        <div title="edition">Statistiques</div>
                        <p><i><xsl:text>Note: les "discours" sont définis par l'emploi des guillemets dans le texte édité.</xsl:text></i></p>
                        <xsl:for-each select="//particDesc//person">
                            
                            <xsl:variable name="idPerson"><!--Variable locale avec l'id de chaque personnage, qui sera utilisé dans les attributs ci dessous-->
                                <xsl:value-of select="./@xml:id"/>
                            </xsl:variable>
                            
                            <!--Concaténation du nom des personnages-->
                            <div class="card">
                                <xsl:for-each select=".">
                                    <xsl:choose>
                                        <xsl:when test=".//forename">
                                            <h4><xsl:value-of select="concat(.//forename, ' ', .//surname)"/></h4>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <h4><xsl:value-of select=".//persName"/></h4>
                                        </xsl:otherwise>
                                    </xsl:choose> 
                                </xsl:for-each>
                                
                                <!-- Mentions du personnages -->
                                <p><b><xsl:text>Nombre de mentions au total: </xsl:text></b>
                                    <xsl:value-of select="count(ancestor::TEI//body//persName[replace(@ref, '#', '') = $idPerson] | ancestor::TEI//body//rs[replace(@ref, '#', '') = $idPerson])"/>
                                </p>
                                
                                <!-- Détail des mentions directes -->    
                                <p><i><xsl:text>Dont </xsl:text></i>
                                    <xsl:value-of select="count(ancestor::TEI//body//persName[replace(@ref, '#', '') = $idPerson])"/>
                                    <i><xsl:text> mention(s) directe(s) (le personnage est appelé par son nom)</xsl:text></i>
                                </p>
                                
                                <!-- Détail des mentions indirectes -->
                                <p>
                                    <i><xsl:text>Et </xsl:text></i><!-- D'abord un décompte des mentions indirectes -->
                                    <xsl:value-of select="count(ancestor::TEI//body//rs[replace(@ref, '#', '') = $idPerson])"/>
                                    <i><xsl:text> mention(s) indirecte(s)</xsl:text></i>
                                </p>
                                <ol><!-- Suivi des qualificatifs employés par ces mentions indirectes -->
                                    <xsl:for-each select="ancestor::TEI//body//rs[replace(@ref, '#', '') = $idPerson]">
                                        <li>"<xsl:value-of select="./text()"/>"</li>
                                    </xsl:for-each>
                                </ol>
                                
                                
                                <!-- Compte des discours des personnages -->
                                <p>
                                    <b><xsl:text>Discours référencés (total): </xsl:text></b>
                                    <xsl:value-of select="count(ancestor::TEI//body//said[replace(@who, '#', '') = $idPerson])"/>
                                </p>
                                
                                <!-- Détail des pensées/réflexions -->
                                <p>
                                    <i><xsl:text>Dont </xsl:text></i>
                                    <xsl:value-of select="count(ancestor::TEI//body//said[@aloud = 'false' and replace(@who, '#', '') = $idPerson])"/>
                                    <i><xsl:text> discours non exprimé(s) à voix haute, tels que pensées et réflexions personnelles.</xsl:text></i>
                                </p>
                                
                                <!-- Détail des paroles prononcées à haute voix -->
                                <p>
                                    <i><xsl:text>Et </xsl:text></i>
                                    <xsl:value-of select="count(ancestor::TEI//body//said[@aloud = 'true' and replace(@who, '#', '') = $idPerson])"/>
                                    <i><xsl:text> discours exprimé(s) à voix haute et destiné(s) à être entendu(s) par l'entourage.</xsl:text></i>
                                </p>
                                
                                <!-- Analyse du discours -->
                                <p>
                                    <b><xsl:text>Analyse du discours exprimé</xsl:text></b>
                                </p>
                                
                                <!-- Nombre de paroles non destinées à quelqu'un en particulier-->
                                <p>
                                    <xsl:value-of select="count(ancestor::TEI//body//said[@direct = 'false' and replace(@who, '#', '') = $idPerson])"/>
                                    <i><xsl:text> de ces discours exprimés à voix haute n'étai(en)t pas adressé(s) à une personne spécifique. Il s'agit d'exclamation(s) adressée(s) à l'ensemble du groupe.</xsl:text></i>
                                </p> 
                                
                                <!-- Destinataires des discours -->
                                <!-- pour chaque discours dit par le personnage, groupé par interlocuteur, on veut sortir le nom de cet interlocuteur -->
                                <xsl:for-each-group select="ancestor::TEI//body//said[@direct = 'true' and replace(@who, '#', '') = $idPerson]" group-by="./@toWhom">
                                    
                                    <xsl:variable name="whomPerso"><!-- Déclaration d'une variable locale reprenant l'ID de la personne à qui l'on s'adresse -->
                                        <xsl:value-of select="replace(./@toWhom,'#','')"/>
                                    </xsl:variable>
                                    
                                    <p>
                                        <xsl:text>Nombre de fois où le personnage s'adresse à  </xsl:text>
                                        <xsl:value-of select="ancestor::TEI//particDesc//person[@xml:id=$whomPerso]/persName"/><!-- On prend le nom de l'interlocuteur--> 
                                        <xsl:text>: </xsl:text>
                                        <xsl:value-of select="count(ancestor::TEI//body//said[replace(@who, '#', '') = $idPerson and replace(@toWhom,'#','') = $whomPerso])"/>
                                    </p><!-- puis on compte ses intéractions -->
                                </xsl:for-each-group>
                            </div>
                        </xsl:for-each>
                    </main>                                
                    <xsl:copy-of select="$footer"/> 
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    

</xsl:stylesheet>