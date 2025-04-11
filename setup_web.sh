#!/bin/bash

# Mettre à jour le système
sudo apt-get update

# Installer Apache et PHP
sudo apt-get install -y apache2 php libapache2-mod-php php-mysql

# Créer une page web simple
sudo tee /var/www/html/index.php > /dev/null <<EOL
<!DOCTYPE html>
<html>
<head>
    <title>Application Web Simple</title>
</head>
<body>
    <h1>Bonjour depuis <?php echo \$_SERVER['SERVER_ADDR']; ?></h1>
    <form method="post" action="save.php">
        <label for="data">Entrez une donnée :</label>
        <input type="text" id="data" name="data">
        <button type="submit">Envoyer</button>
    </form>
    <h2>Données enregistrées :</h2>
    <?php
    \$conn = new mysqli("192.168.56.20", "root", "password", "testdb");
    if (\$conn->connect_error) {
        die("Connection failed: " . \$conn->connect_error);
    }
    \$result = \$conn->query("SELECT * FROM data");
    while (\$row = \$result->fetch_assoc()) {
        echo "<p>" . \$row['value'] . "</p>";
    }
    \$conn->close();
    ?>
</body>
</html>
EOL

# Créer le script pour sauvegarder les données
sudo tee /var/www/html/save.php > /dev/null <<EOL
<?php
\$conn = new mysqli("192.168.56.20", "root", "password", "testdb");
if (\$conn->connect_error) {
    die("Connection failed: " . \$conn->connect_error);
}
\$data = \$_POST['data'];
\$sql = "INSERT INTO data (value) VALUES ('\$data')";
if (\$conn->query(\$sql) === TRUE) {
    echo "Donnée enregistrée avec succès !";
} else {
    echo "Erreur : " . \$conn->error;
}
\$conn->close();
header("Location: index.php");
?>
EOL

# Redémarrer Apache
sudo systemctl restart apache2