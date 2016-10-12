<?php
    if(isset($_POST['boton'])){
        if($_POST['nombre'] == ''){
            $errors[1] = '<span class="error">Ingrese su nombre</span>';
        }else if($_POST['email'] == '' or !preg_match("/^[a-zA-Z0-9_\.\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-\.]+$/",$_POST['email'])){
            $errors[2] = '<span class="error">Ingrese un email correcto</span>';
        }else if($_POST['mensaje'] == ''){
            $errors[3] = '<span class="error">Ingrese un mensaje</span>';
        }else{
            $nombre = $_POST['nombre'];
            $email = $_POST['email'];
            $telefono = $_POST['telefono']; //Asunto
            $cuerpo = $_POST['mensaje']; //Cuerpo del mensaje
            $todo = $nombre."~".$email."~".$telefono."~".$cuerpo;  
            $fp = fopen("peticiones.txt","a+");    
            fwrite($fp, $todo.PHP_EOL);
            fclose($fp);
            if($copiado != TRUE){
             $result = '<div class="result_ok">Su correo ha sido enviado correctamente</div>';   
            }else{
             $result = '<div class="result_ok">No se pudo mandar su correo</div>';
            }            
}
   }
?>
<html>
    <head>
        <title>Contacto</title>
        <link rel='stylesheet' href='estilos.css'>
        <script src='http://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js'></script>
        <script src='funciones.js'></script>
    </head>
    <body>
        <form class='contacto' method='POST' action=''>
            <div><label>Tu Nombre:</label><input type='text' class='nombre' name='nombre' value='<?php echo $_POST['nombre']; ?>'><?php echo $errors[1] ?></div>
            <div><label>Tu Email:</label><input type='text' class='email' name='email' value='<?php echo $_POST['email']; ?>'><?php echo $errors[2] ?></div>
            <div><label>Tu telefono:</label><input type='text' class='telefono' name='telefono' value='<?php echo $_POST['telefono']; ?>'>
            <div><label>Mensaje:</label><textarea rows='6' class='mensaje' name='mensaje'><?php echo $_POST['mensaje']; ?></textarea><?php echo $errors[3] ?></div>
            <div><input type='submit' value='Envia Mensaje' class='boton' name='boton'></div>
            <?php echo $result; ?>
        </form>
    </body>
</html>
