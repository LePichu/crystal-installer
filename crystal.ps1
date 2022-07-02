switch ($Env:Path -match "CRYSTAL_PATH") {
    False {
        $old_path = [Environment]::GetEnvironmentVariable("PATH")
        if ($Env:OS -match "win") {
            [Environment]::SetEnvironmentVariable("PATH", "$old_path;%CRYSTAL_PATH%", "Machine")
        }
        else {
            [Environment]::SetEnvironmentVariable("PATH", "$old_path;`$CRYSTAL_PATH", "Machine")
        }
    }
}


$IsWin = $Env:OS -match "win"
$ver = switch($args[0]) {
    "" {
        "1.4.1"
    }
    default {
        $args[0]
    }
}
$url = switch($IsWin) {
    True {
        "https://github.com/crystal-lang/crystal/releases/download/$ver/crystal-$ver-windows-x86_64-msvc-unsupported.zip"
    }
    False {
        if($IsLinux) {
            "https://github.com/crystal-lang/crystal/releases/download/$ver/crystal-$ver-1-linux-x86_64.tar.gz"
        }
        else {
            "https://github.com/crystal-lang/crystal/releases/download/$ver/crystal-$ver-1-darwin-universal.tar.gz"
        }
    }
}

$ender = switch($IsWin) {
    True {
        "zip"
    }
    False {
        "tar.gz"
    }
}

mkdir "$Global:HOME\.crystal\temp"
mkdir "$Global:HOME\.crystal\ver\$ver\"

Invoke-WebRequest $url -OutFile "$Global:HOME\.crystal\temp\crystal-$ver.$ender" 
tar -xf "$Global:HOME\.crystal\temp\crystal-$ver.$ender" --directory "$Global:HOME\.crystal\ver\$ver\"

if ($IsWin) {
    [Environment]::SetEnvironmentVariable("CRYSTAL_PATH", "$Global:HOME\.crystal\ver\$ver\", "Machine")
}
else {
    [Environment]::SetEnvironmentVariable("CRYSTAL_PATH", "$Global:HOME\.crystal\ver\$ver\crystal-$ver-1\bin", "Machine")
}

Write-Output "Crystal has been installed!"