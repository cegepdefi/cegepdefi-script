# RUN:
# powershell -ExecutionPolicy Bypass -File .\rename_img_with_numbers.ps1

# Extensiones soportadas
$exts = @("png","jpg","jpeg","webp","gif","bmp","tiff","jfif")

# Obtener imágenes del folder actual (compatible con PowerShell 5.1)
$images = Get-ChildItem -File | Where-Object {
    $exts -contains $_.Extension.TrimStart(".").ToLower()
}

# Orden natural manual (igual que Explorer)
$sorted = $images | Sort-Object {
    if ($_ -match '\d+') {
        [int]([regex]::Match($_.Name, '\d+').Value)
    } else {
        $_.Name
    }
}

# Contador inicial
$counter = 1

foreach ($img in $sorted) {

    # Generar número con dos dígitos (01, 02, 03...)
    $num = "{0:D2}" -f $counter

    # Nuevo nombre manteniendo la extensión original
    $newName = "$num$($img.Extension)"

    Write-Host "Renombrando: $($img.Name) → $newName"

    # Renombrar archivo
    Rename-Item -LiteralPath $img.FullName -NewName $newName

    # Incrementar contador
    $counter++
}

Write-Host "`nProceso completado."
