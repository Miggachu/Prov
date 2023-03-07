#Remove-Item "C:\temp\Porvoo.db"

$csvfilepath = "C:\temp\Borgo.csv"

$imp = Import-Csv  $csvfilepath -Encoding UTF7 -Delimiter ';' 

$Databas = "C:\temp\Porvoo.db"


$Query = "CREATE TABLE Porvoo (id INTEGER PRIMARY KEY, 

kustannus_id INTEGER, 
kustannus_name TEXT,
tosite_number INTEGER,
tositename TEXT,
euro_brutto REAL,
rondo_id INTEGER);"
 

invoke-SqliteQuery -Query $Query -DataSource $Databas

 $imp | ForEach-Object {

                 $kustannus_id = $_.Kustannuspaikka
                 $kustannus_name = $_.'Kustannuspaikan nimi'.replace("'",'"')
                 $tosite_number = $_.Tositenumero
                 $tositename = $_.Selite.replace("'",'"')
                 $euro_brutto = $_.'EUR, brutto'.replace(" ","").replace(",",".")
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

                   Invoke-SqliteQuery -Query $Query -DataSource $Databas
}

$Lista = Invoke-SqliteQuery -Query "Select * from Porvoo;" -DataSource $Databas


$Query = "Select 
           
           kustannus_id,
           kustannus_name,
           Sum(euro_brutto)
           FROM
           Porvoo
           GROUP BY
           Kustannus_id
           ORDER BY SUM(euro_brutto) DESC
           Limit 5;"
           Invoke-SqliteQuery -Query $Query -DataSource $Databas



           ## ta antagligen bort MIL eftersom python förväntar sig siffror och inte text (gör en tool tip istället dummy)

$top5table = "CREATE TABLE top5 AS
              SELECT
              kustannus_id, 
              kustannus_name,
              ROUND (SUM(euro_brutto)/1000000,2) AS Euro_brutto
              FROM Porvoo
              GROUP BY Kustannus_id
              ORDER BY SUM(euro_brutto) DESC
              Limit 5;"

           Invoke-SqliteQuery -Query $top5table -DataSource $Databas


$5list = Invoke-SqliteQuery -Query "Select * from top5;" -DataSource $Databas



$Color = "CREATE TABLE colors (id INTEGER PRIMARY KEY, 

R INTEGER, 
G INTEGER,
B INTEGER);"

invoke-SqliteQuery -Query $Color -DataSource $Databas

$Color = "INSERT INTO colors (r, g, b)                  
                             VALUES
                             
                               ('255','64','105'),
                               ('5','155','255'),
                               ('51','29','6'),
                               ('34','207','207'),
                               ('255','194','52');"

                   Invoke-SqliteQuery -Query $Color -DataSource $Databas


$COLista = Invoke-SqliteQuery -Query "Select * from colors;" -DataSource $Databas

#Invoke-SqliteQuery -Query $drop -DataSource $Databas
# $drop = "Drop table top5"









           
           
           
           
           
           
                                               












