# ProyectTemplate

Intrucciones para levantar proyectos symfony

- correr el bash init.sh
    `./init.sh`
    - definir nombre del proyecto, puerto nginx y version de symfony
    - con esto deberian estar levantados los contenedores 

para configurar xdebug (solo en ambiente dev) hay que agregar

- hay que agregar un carpeta si no esta creada .vscode dentro crear el archivo launch.json donde hay que agregar esta configuración

`{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Listen for Xdebug",
            "type": "php",
            "request": "launch",
            "port": 9003 //este puerte debe ser el puerto que esta asignado en la configuración (archivo .ini) de xdebug,
            "pathMappings": {
                "/ReplaceWithWorkingDirectoryInContainer": "${workspaceFolder}"
            }
        }
    ]
}`

# importante 

por ultimo eliminar .init.sh y carpeta .git una ves esta todo configurado y he iniciar un nuevo repo y pushear con force el primer commit.