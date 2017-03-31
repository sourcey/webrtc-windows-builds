:: ##############################################
:: Download WebRTC
::

set DEPOT_TOOLS_WIN_TOOLCHAIN=0

if not "%1"=="" (
	echo "Syncing branch %1"
	cd src
	call git stash
	call git branch -r
	call git checkout branch-heads/57
	cd ..
)
::set BRANCH = "%1"
::if "%1"=="" ( set BRANCH="master" ) 
::ELSE ( SET "DatabaseServer=%1" )

call fetch --nohooks webrtc
call gclient sync