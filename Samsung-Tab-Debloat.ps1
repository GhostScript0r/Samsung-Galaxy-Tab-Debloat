param(
    [switch]$DisableChrome,
    [switch]$KeepDailyBoard
)
where.exe adb.exe
if($lastexitcode -eq 1) { # ADB not installed
    Write-Host "ADB is not installed or not in the %PATH%" -ForegroundColor Red
    exit
}
[string[]]$AppsToRemove=@(
    "com.google.android.apps.youtube.music"
    "com.google.android.videos"
    "com.samsung.android.mobileservice"
    "com.samsung.android.messaging"
    "com.samsung.android.dialer"
    "com.samsung.android.app.contacts"
    "com.samsung.android.ardrawing"
    "com.samsung.android.arzone"
    "com.samsung.android.incallui"
    "com.samsung.android.mdecservice"
    "com.samsung.android.app.telephonyui"
    "com.samsung.android.bixbyvision.framework"
    "com.samsung.android.bixby.wakeup"
    "com.samsung.android.bixby.agent"
    "com.samsung.android.app.settings.bixby"
    "com.samsung.android.app.spage"
    "com.sec.android.app.myfiles"
    "com.sec.android.app.myfiles"
    "com.sec.android.app.samsungapps"
    "com.netflix.partner.activation"
    "com.netflix.mediaclient"
    "com.samsung.android.app.notes"
    "com.samsung.android.spdfnote"
    "com.samsung.android.app.notes.addons"
    "com.osp.app.signin"
    "com.samsung.android.visionintelligence"
    "com.samsung.android.bbc.bbcagent"
    "com.samsung.android.bixby.agent.dummy"
    "com.samsung.android.app.talkback"
    "com.samsung.android.app.settings.bixby"
    "com.samsung.android.game.gamehome"
    "com.samsung.android.wellbeing"
    "com.samsung.knox.securefolder"
    "com.samsung.systemui.bixby"
    "com.samsung.systemui.bixby2"
    "com.samsung.android.app.tips"
    "com.sec.android.easyMover"
    "com.sec.android.easyMover.Agent"
    # "com.rsupport.rs.activity.rsupport.aas2" # Samsung support app. If you also installs my dummy app then this app won't needed to be removed.
    "com.samsung.android.privateshare"
    "com.samsung.android.mapsagent"
    "com.samsung.android.da.daagent"
    "com.samsung.app.newtrim"
    "com.samsung.android.app.omcagent"
    "com.samsung.android.fmm"
    "com.samsung.android.forest"
    "com.samsung.android.scpm"
    "com.samsung.android.scloud"
    "com.sec.android.app.billing"
    "com.samsung.android.vtcamerasettings"
    "com.samsung.android.video"
    "com.samsung.SMT"
    "com.samsung.android.app.reminder"
)
if($DisableChrome) {
    $AppsToRemove=$AppsToRemove+@("com.android.chrome")
}
if(!($KeepDailyBoard)) {
    $AppsToRemove=$AppsToRemove+@(
    "com.samsung.android.homemode"
    "com.samsung.android.calendar"
    "com.sec.android.daemonapp"
    )
}
foreach($App in $AppsToRemove) {
    if($(adb shell pm list package $App) -like "package:$App") {
        Write-Host "Uninstalling $App" -ForegroundColor Yellow
        if($(adb shell pm path $App) -like "/data/*/base.apk*") {
            adb uninstall $App # To uninstall possible updates
        }
        adb shell pm clear $App # Clear application data completely
        adb shell pm uninstall -k --user 0 $App
    }
    else {
        Write-Host "$App is already uninstalled." -ForegroundColor Green
    }
}