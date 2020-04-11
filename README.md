# Config to release an App


***


## Agregar icono


### Instalar flutter_launcher_icon

> En pubspec.yaml, bajo dev dependencies, agregar
>
>
`dev_dependencies:
  flutter_test:
  sdk: flutter
  flutter_launcher_icons: ^0.7.4`

### Agregar icono en 1024 x 1024

> En pubspec.yaml, al mismo nivel de dev dependencies
>

`flutter_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon/icon.jpg"`

### Crear carpeta 'icon' en assets y agregar la imagen del icono

> src -> icon -> icon.jpg

### Run this commands

`flutter packages get`

`flutter packages run flutter_launcher_icons:main`

***

## CONFIGURAR SPLASH SCREEN

> Abrir el archivo launch_background.xml
>
> android -> app -> src -> main -> res -> drawable -> launch_background.xml
>
> Remove <!-- --> and change this line like this -> ' `android:src="@mipmap/launcher_icon"` '
>
> You can also change the splash screen color in -> ' `<item android:drawable="@android:color/white" />` '


***


## Ajustar el nombre de la app

> En AndroidManifest.xml agregar:
>
`android:label="nameOfMyApp"`


***


## Deplayment to PlayStore

### Cambiar el nombre de la App

> Buscar y abrir el archivo build.gradle, el que se encuentra dentro de la carpeta android -> app
>
> Edit this line
>

`defaultConfig {
   applicationId "com.devName.appName" ... }`

> Ahora buscar y abrir el archivo AndroidManifest.xml, que se encuentra dentro de la carpeta android -> app -> src -> main
>
> Edit this line

`<manifest xmlns: android="http ://schemas.android.com/apk/res/android"
   package="com.devName.appName"> `

> Ambos nombres deben ser iguales!


### Cambiar la version de la App (cada vez que se haga despliegue)

> En el archivo build.gradle que se encuentra dentro de la carpeta android -> app
>

 `defaultConfig {....
    .....
    versionCode 1
    versionName "1.0.0"` ....



### Especificar la version minima para usar la App

> En el mismo archivo build.gradle

`defaultConfig {....
    minSdkVersion 16
    targetSdkVersion 28`

> Se puede dejar por defecto


***


## Firmar la App

> Con la keystore ya generada, se debe crear en la carpeta android, un archivo llamado
>
`key.properties`
>
> Agregar la info del key.jks al archivo (copypaste)


***


## Agregar key.properties al .gitignore (y también el archivo de getUnitId() de admob)

> Agregar al final del archivo


***


## Configurar la firma en gradle

> En el archivo build.gradle que se encuentra dentro de la carpeta android -> app
>
> Reemplazar todo `buildtypes {.. ` con

    `signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
       release {
           signingConfig signingConfigs.release
       }
    }`

***


## Generar version de 64bits

> En el archivo build.gradle que se encuentra dentro de la carpeta android -> app
>
> Debajo de
>

    `flutter {  
        source '../..'  
    }`

> Agregar

    `afterEvaluate {
        mergeReleaseJniLibFolders.doLast {
            def archTypes = ["arm-release", "arm64-release"]
            archTypes.forEach { item ->
                copy {
                    from zipTree("$flutterRoot/bin/cache/artifacts/engine/android-$item/flutter.jar")
                    include 'lib/*/libflutter.so'
                    into "$buildDir/intermediates/jniLibs/release/"
                    eachFile {
                        it.path = it.path.replaceFirst("lib/", "")
                    }
                }
            }
        }
    }`



***


## Generar la version de produccion de la App en formato AppBundle

> Correr el código en la terminal, posicionarse en el root del proyecto y escribir

`flutter clean`

> y luego

`flutter build appbundle`

> Se guarda en <appRoot>/build/app/outputs/bundle/release/app-release.aab

> Por otro lado, para AppStores que no tienen soporte para AppBundle, correr el comando

`flutter build apk --split-per-abi`

>> No recomendado `flutter build appbundle --target-platform android-arm,android-arm6`
>> (Correr `flutter build apk --release` genera un .apk, no un .ab )


***


## Finalmente subir a PlayStore

Y eso es todo