<# Vi börjar med att importera CSV filen som vi har laddat ner från"Avoindata.fi" och deklarear en variabel som leder till mappen filen är lagrad i. Med vår $imp variabel så importerar vi vår csv fil och ger den en
UTF7 encoding är till för att representera unicode text i en ström av ASCII karaktärer samt en Delimiter ';' som är en avgränsare för ett eller flera tecken för att specificera gränsen mellan separata, oberonde regioner i vanlig text.*>


# File path till csv filen
$csvfilepath = "C:\temp\Borgo.csv"

# Importerar csv filen, ge den en encoding och sätt en delimiter.
$imp = Import-Csv  $csvfilepath -Encoding UTF7 -Delimiter ';' 

# Skapa Databasen .db filen.
$Databas = "C:\temp\Porvoo.db"

# Skapa första tabellen, ge den en PRIMARY KEY(ger ett unikt id till varje rad i tabellen) 
ett namn samt ge de olika raderna olika data typer i form av (TEXT, REAL och INTEGER, mm)
$Query = "CREATE TABLE Porvoo (id INTEGER PRIMARY KEY, 

                                kustannus_id INTEGER, 
                                kustannus_name TEXT,
                                tosite_number INTEGER,
                                tositename TEXT,
                                euro_brutto REAL,
                                rondo_id INTEGER);"
 
 # specificerar vilken query som skall köras och vilken data källa den skall köras emot. 
invoke-SqliteQuery -Query $Query -DataSource $Databas

 
 <# Gör en ForEach loop där man plockar ut den informationen man vill ha ur csv filen och byter namn och ersätter specialtecken med replace ("","") 
 för att sedan sätta in den nya informationen i tabellen med INSERT INTO(tabellens namn).
 I första delen så kopplar vi de nya namnen till de gamla värderna t.ex. kustannus_id = $_.Kustannuspaikka
 med this ($_.) som används för arr referera till ett specifikt objekt.
 under $Query så matar vi in den nya informationen kolumn namnen och deras värde i tabellen.
 
 #> 
 $imp | ForEach-Object {

                 $kustannus_id = $_.Kustannuspaikka
                 $kustannus_name = $_.'Kustannuspaikan nimi'.replace("'",'"') #(replace"'",'"') ersätter enkelt citattecken med citattecken.
                 $tosite_number = $_.Tositenumer
                 $tositename = $_.Selite.replace("'",'"') #(replace"'",'"') ersätter enkelt citattecken med citattecken.
                 $euro_brutto = $_.'EUR, brutto'.replace(" ","").replace(",",".") #(replace"'",'"') ersätter enkelt kommatecken med punkt.
                 $rondo_id = $_.'Rondo ID'

                 $Query = "INSERT INTO Porvoo (kustannus_id,
                                               kustannus_name,
                                               tosite_number,
                                               tositename,
                                               euro_brutto,
                                               rondo_id
                                               )
                                                 VALUES
                                                 ( '$kustannus_id',
                                                   '$kustannus_name',
                                                   '$tosite_number',
                                                   '$tositename',
                                                   '$euro_brutto',
                                                   '$rondo_id');"

# Specificerar vilken query som skall köras och vilken data källa den skall köras emot.
                   Invoke-SqliteQuery -Query $Query -DataSource $Databas
}

# Skapar en variabel som väljer all information från vår "Porvoo" tabell och visar upp den.
$Lista = Invoke-SqliteQuery -Query "Select * from Porvoo;" -DataSource $Databas

#Skapa andra tabellen, ge den en PRIMARY KEY och ett namn.
<# Plocka ut kustanus_id, kusanus_name och eur_brutto från vår "Porvoo" tabell sedan så avrundar den med (ROUND)
 eur_brutto till det närmsta 2 decimalerna samt delar summan med en miljon och ger den en alias av "Euro_brutto",
 för att sedan gruppera (GROUP BY) det i ordning av kustanus_id och sortera det efter eur_brutto(ORDER BY) i en sjunkande ordning(DESC) 
 och limitera det (LIMIT) till 5 resultat för att få ut top 5 resultat i samband med det 5 högsta summorna.*>
$top5table = "CREATE TABLE top5 AS
              SELECT
              kustannus_id, 
              kustannus_name,
              ROUND (SUM(euro_brutto)/1000000,2) AS Euro_brutto
              FROM Porvoo
              GROUP BY Kustannus_id
              ORDER BY SUM(euro_brutto) DESC
              Limit 5;"

# Specificerar vilken query som skall köras och vilken data källa den skall köras emot.
  Invoke-SqliteQuery -Query $top5table -DataSource $Databas


# skapar en variabel som väljer all information från vår "top5" tabell och visar upp den.
$5list = Invoke-SqliteQuery -Query "Select * from top5;" -DataSource $Databas



# Hexadecimal färg tabell(se första tabellen för referens)
$Hextable = "CREATE TABLE hexcol 

(id INTEGER PRIMARY KEY, 
 HEX TEXT);"

# Specificerar vilken query som skall köras och vilken data källa den skall köras emot.
invoke-SqliteQuery -Query $Hextable -DataSource $Databas

<# Viktigt för hexadecimala skall fungera så måste du lägga till # tecknet i din python kod vilket man kan göra med denna bit av kod 
for row in colors:
    color.append("#"+row[0])
#>
$Hexa = "INSERT INTO hexcol (HEX)                 
                             
                             VALUES
                             
                               ('059bf'),
                               ('ffc234'),
                               ('22cfcf'),
                               ('ff4069'),
                               ('ff9020');"
                               
# Specificerar vilken query som skall köras och vilken data källa den skall köras emot.
                   Invoke-SqliteQuery -Query $Hexa -DataSource $Databas

# skapar en variabel som väljer all information från vår "hexcol" tabell och visar upp den.
$Hexlista = Invoke-SqliteQuery -Query "Select * from hexcol;" -DataSource $Databas









           
           
           
           
           
           
                                               












