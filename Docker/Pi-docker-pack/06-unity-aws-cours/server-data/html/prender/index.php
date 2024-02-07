<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>prender</title>
</head>
<body>

<?php
if(isset($_POST['prenderServer1'])) {
    $laIp = "0.0.0.0";
    $macAdd = '00:00:a0:00:00:ab';
    $PingResultado = pingPc($laIp);
    if (!$PingResultado) prenderPc($laIp, $macAdd);
}

function pingPc($host) {
    echo "Haciendo ping";
    exec("ping -c 4 " . $host, $output, $result);
    print_r($output);
    if ($result == 0)
    {
        echo "Ping successful!";
        return true;
    }
    else
    {
        echo "Ping unsuccessful!";
        return false;
    }
}

function prenderPc($host, $macAdd) {
    echo "Prendiendo server";
    //$output = shell_exec('ls');
    //$output = shell_exec('apt install -y wakeonlan');
    //$output = shell_exec('wakeonlan 00:00:a0:00:00:ab');
    //echo "<pre>$output</pre>";
    //PHP_WOL::send($host, $macAdd, 9);
    pingPc($host);
}
?>

<form method="post">
    <input type="submit" name="prenderServer1" value="prender Server1" />
</form>

</body>
</html>