# mtools
Assorted MATLAB tools I use throughout my MATLAB code. I try to capture common tasks in MATLAB functions, in an attempt to keep my code clean and modular. Essentially I'm trying [not to repeat myself](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself). Hopefully, each one of these functions is self-contained and can be re-used in different scenarios. Do use this code for whatever purpose. If you spot any issues please let me know. Feel free to enlighten me with better ways to code any of this :thumbsup:. <br />
Email me at: `regexprep({'fabio-nery-13_ucl-ac-uk'}, {'-','_'}, {'.','@'})`. <br />

mtools index:
-------------

- **[dcm]**
  - `dcmfind.m`: List DICOM files in dir (and its subdirs)
  - `dcmsiemensisolateascconv.m`: isolates ASCCONV part in Siemens CSA headers <br />
  - `dcmsiemenscsa.m`: parse DICOM Siemens CSA header (ASCCONV subset only) <br />
- **[fig]**
  - `crop.m`: crop image and/or sets of coordinates
  - `imcheckerboard.m`: display checkerboard of two images
  - `imclipint.m`: clip image intensities
  - `imtest.m`: loads 2D or 3D test image from MATLAB's MRI dataset
  - `imx.m`: custom imshow/montage function
  - `imxov.m`: create ImxOv struct for parametric map overlay in imx.m <br />
  - `mgridshape.m`: get montage grid shape (can constrain nRows/nColumns) <br />
  - `selectroi.m`: draw ROIs in the displayed image and create corresponding masks <br />
  - `vol2mont.m`: converts a 3D volume into a 2D montage <br />
  - `xy2xyz.m`: convert point 2D (xy (as in montage)) to 3D (xyz) coordinates <br />
  - `xyz2xy.m`: convert point 3D (xyz) to 2D (xy) coordinates (as in montage) <br />
- **[misc]**
  - `authstr.m`: creates author string for function documentation <br />
  - `bwcircle.m`: Creates binary (logical) image with a 1-valued circle <br />
  - `cell2str.m`: converts [n x 1] cell of strings to a [n x nChars] string <br />
  - `cellstrmatch.m`: create new cell from matching(or not) strings in input cell <br />
  - `changewrtbaseline.m`: change in measurements with respect to a "baseline" <br />
  - `cleanstr.m`: replace spaces by underscores and remove non-alphanum chars <br />
  - `ctime.m`: creates string with current date-time (yyyymmdd_hhmmss[fff]) <br />
  - `dispstrcell.m`: generate matlab code to re-create cell of strings variable <br />
  - `fdir.m`: custom dir function <br />
  - `filepartscell.m`: extends matlab's fileparts for "cell of strings" inputs <br />
  - `fxdoc.m`: prints function documentation template to command window <br />
  - `getabovedir.m`: returns path of directories closer to the root <br />
  - `is1d.m`: check if input is 1D "vector" <br />
  - `isallequal.m`: checks if all elements in the array are equal <br />
  - `isint.m`: checks if the input is an integer <br />
  - `logic2str.m`: converts logical scalar to string <br />
  - `lsfile.m`: list files in dir and pick according to file # index <br />
  - `m2sharr.m`: convert cell of strings to space-delimited list (like bash arrays) <br />
  - `matrix2string.m`: converts 2D matrix to text (figure displaying purposes) <br />
  - `mkdirf.m`: extends mkdir.m function (automatic name/overwrite control) <br />
  - `mtools.m`: displays index of functions in mtools in the command window <br />
  - `nvargins2struct.m`: converts cell of argins (name-value pairs) into a struct <br />
  - `reparrew.m`: replicate array (element-wise) <br />
  - `scriptdoc.m`: prints script documentation template to command window <br />
  - `sortstruct.m`: sorts struct according to one of its fields <br />
  - `squeezext.m`: extends squeeze.m (specify singleton dimensions keep/remove) <br />
  - `strpad.m`: pad string with spaces to achieve a certain length <br />
  - `sumn.m`: sum of array elements along multiple dimensions (sum in a loop) <br />
  - `uniquesubstr.m`: remove duplicate substrings from string <br />
  - `vec2str.m`: converts a 1D-vector to a string <br />
  - `yyyymmddfind.m`: finds and extracts date substrings of format 'yyyymmdd' <br />

External code
-------------

Some of the functions in the above list use code written by others, which I typically get from [MATLAB's File Exchange](mathworks.com/matlabcentral/fileexchange/) or other GitHub repositories. For simplicity, copies of such code are incorporated in this repository (`ext` folder), each function in its specific subdirectory. Attribution and licenses are included whenever possible. A summary of the external code included in this repository is as follows:

### External code index

- `progressbar.m`: simple, efficient, and user friendly replacement for waitbar
  - Copyright (c) 2005, Steve Hoelzer
  - Retrieved from [FEX-progressbar](https://uk.mathworks.com/matlabcentral/fileexchange/6922-progressbar) on 20170324
- `subdir.m`: performs a recursive file search
  - Copyright (c) 2015 Kelly Kearney
  - Retrieved from [subdir-pkg](https://github.com/kakearney/subdir-pkg) on 20170324

In addition, some of my functions may incorporate code snippets from others. This will be detailed in the documentation of each function. 

___
___

Copyright (c) 2017, Fabio Nery <br />
All rights reserved. <br />

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

- Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
- Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
