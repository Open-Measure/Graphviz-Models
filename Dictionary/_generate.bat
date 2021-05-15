ECHO OFF
CLS
ECHO.
ECHO Image and maps generation script from DOT files 
ECHO Author: Open-Measure

ECHO.
ECHO Our gratitude to these amazing dependencies:

ECHO.
ECHO Graphviz
ECHO Reference: https://graphviz.org/
SET GraphViz_Path="C:\Program Files (x86)\Graphviz2.38\bin"

ECHO.
ECHO Inkscape
ECHO Reference: https://wiki.inkscape.org/wiki/index.php/Using_the_Command_Line
SET Inkscape_Path="C:\Program Files\Inkscape\bin"

ECHO.
ECHO node.js
ECHO Reference: https://nodejs.org/

ECHO.
ECHO svgexport
ECHO Reference: https://github.com/shakiba/svgexport
ECHO Installation: npm install svgexport --save
ECHO Run this script in command prompt environment setup for Node

REM ECHO.
REM ECHO ImageMagick
REM ECHO Website: https://imagemagick.org/script/command-line-options.php#extent
REM SET ImageMagick_Path="C:\Program Files\ImageMagick-7.0.11-Q16-HDRI"

SET DIC_Path="%HOMEPATH%\OneDrive\Data\Graphviz Models\graphviz-models\Dictionary"
CD %DIC_Path%

SET DPI=300

FOR %%F IN (%DIC_Path%\system.gv) DO (
	ECHO. 
	ECHO *********************
    ECHO * %%~nF
	ECHO *********************
	ECHO.
	ECHO Graphviz native exports
	ECHO Native Graphviz SVG file may have rendering issues
	%GraphViz_Path%\dot -Tsvg -Gdpi=%DPI% -o"%%~nF.svg" "%%~fF"
	%GraphViz_Path%\dot -Tpdf -Gdpi=%DPI% -o"%%~nF.pdf" "%%~fF"
	%GraphViz_Path%\dot -Tpng -Gdpi=%DPI% -o"%%~nF.png" "%%~fF"
	
	REM Issue: GraphViz cannot guarantee an exact output size
	REM %GraphViz_Path%\dot -Tpng -Gsize=10,15\! -Gdpi=%DPI% -o"insider-1000x1500.png" "insider.gv"
	
	REM Issue: ImageMagick fails to read that particular SVG
	REM %ImageMagick_Path%\magick convert "%%~nF.svg" -gravity center -background white -extent 1000x1500 "%%~nF-1000x1500.png"
	
	ECHO.
	ECHO Use Inkscape to cleanup the SVG file
	REM This first processing by Inkscape resolves the following issue:
	REM SVG files directly exported from Graphviz are interpreted
	REM as a blank image by Chrome, Edge and svgexport.
	REM I couldn't find the root cause of this issue but
	REM cleaning it with inkscape solves the problem.
	REM We then could do all the processing with Inkscape but,
	REM bad luck, I couldn't find an easy way to resize the
	REM exported PNG while preserving the image proportions
	REM and padding the horizontal and vertical spaces as necessary.
	%Inkscape_Path%\inkscape --vacuum-defs --export-area-snap --export-area-drawing --export-overwrite --export-type="svg" --export-filename="%%~nF-plain.svg" --export-dpi=%DPI% %%~nF.svg"
	
	ECHO.
	ECHO Use svgexport to generate PNG of Pinterest size 1000x1500
	svgexport "%%~nF-plain.svg" "%%~nF-1000x1500.png" 1000:1500 pad
	
	ECHO.
	ECHO Use svgexport to generate PNG of LinkedIn size 1600x900
	svgexport "%%~nF-plain.svg" "%%~nF-1600x900.png" 1600:900 pad
		
	ECHO.
	ECHO Use svgexport to generate PNG of PowerPoint slide 16/9 size 1920x1080
	svgexport "%%~nF-plain.svg" "%%~nF-1920x1080.png" 1920:1080 pad

)


