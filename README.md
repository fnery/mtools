# mtools
Assorted MATLAB tools I use throughout my MATLAB code. I try to capture common tasks in MATLAB functions, in an attempt to keep my code clean and modular. Essentially I'm trying [not to repeat myself](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself). Hopefully, each one of these functions is self-contained and can be re-used in different scenarios. Sub-functions are used when the same code needs to be called several times by the parent function or simply for better legibility. Do use this code for whatever purpose. If you spot any issues please let me know.
Email: `regexprep({'fabio-nery-13_ucl-ac-uk'}, {'-','_'}, {'.','@'})`. <br />

mtools index:
-------------
- **[asl]**
  - `asl6d.m`: organises a 4D ASL volume into a 6D ASL volume <br />
  - `aslmergenii.m`: sorts and merges 3D ASL NIfTIs into 4D NIfTIs <br />
  - `aslorder.m`: returns order matrix for ASL experiment <br />
- **[dcm]**
  - `dcmfind.m`: List DICOM files in dir (and its subdirs) <br />
  - `dcmsiemensisolateascconv.m`: isolates ASCCONV part in Siemens CSA headers <br />
  - `dcmsiemenscsa.m`: parse DICOM Siemens CSA header (ASCCONV subset only) <br />
- **[dwi]**
  - `bvalbveccheck.m`: validity checks on .bval and .bvec files/matrices <br />
  - `bvalbveccopy.m`: copy bval/bvec files (name to match existing NIfTI file) <br />
  - `bvalbvecexist.m`: check if bval and bvec files exist <br />
  - `bvalbvecinfo.m`: get scan parameters from bval and bvec files <br />
  - `bvalbvecload.m`: load one pair of bval and bvec files <br />
  - `bvalbvecparse.m`: parse a dwi dataset using the bval and bvec files <br />
  - `bvalbvecpath.m`: generate bval/bvec names/paths from corresponding NIfTI image <br />
  - `bvalbvecwrite.m`: write .bval and/or .bvec files from MATLAB arrays <br />
  - `dtifit.m`: FSL's dtifit wrapper <br />
  - `dtifitnm.m`: dtifit and [n] merge [m]  <br />
  - `dtifitpaths.m`: init paths to dtifit outputs <br />
  - `dwi6d.m`: organises a 4D DWI volume into a 6D DWI volume <br />
  - `dwicat.m`: concatenate 3/4D dwi NIfTI files along 4th dimension <br />
  - `dwiextract.m`: extract subset of adjacent time points from DWI dataset <br />
  - `dwiin.m`: dwi input parser <br />
  - `dwiinn.m`: dwiin.m wrapper (for 'n' inputs) <br />
- **[fig]**
  - `crop.m`: crop image and/or sets of coordinates <br />
  - `formatdatatip.m`: change format when displaying plot info using data cursor <br />
  - `imcheckerboard.m`: display checkerboard of two images <br />
  - `imclipint.m`: clip image intensities <br />
  - `imfusion.m`: create fusion image (composite of two images) <br />
  - `imtest.m`: loads 2D or 3D test image from MATLAB's MRI dataset <br />
  - `imx.m`: custom imshow/montage function <br />
  - `imxov.m`: create ImxOv struct for parametric map overlay in imx.m <br />
  - `mgridshape.m`: get montage grid shape (can constrain nRows/nColumns) <br />
  - `selectroi.m`: draw ROIs in the displayed image and create corresponding masks <br />
  - `vol2mont.m`: converts a 3D volume into a 2D montage <br />
  - `xy2xyz.m`: convert point 2D (xy (as in montage)) to 3D (xyz) coordinates <br />
  - `xyz2xy.m`: convert point 3D (xyz) to 2D (xy) coordinates (as in montage) <br />
- **[misc]**
  - `authstr.m`: creates author string for function documentation <br />
  - `bwcircle.m`: Creates binary (logical) image with a 1-valued circle <br />
  - `ccc.m`: cleans MATLAB's cmd window, workspace, figures, etc... <br />
  - `cell2str.m`: converts [n x 1] cell of strings to a [n x nChars] string <br />
  - `cellstrmatch.m`: create new cell from matching(or not) strings in input cell <br />
  - `cf`: [c]urrent [f]older - dir where calling function lives <br />
  - `changewrtbaseline.m`: change in measurements with respect to a "baseline" <br />
  - `cleanstr.m`: replace spaces by underscores and remove non-alphanum chars <br />
  - `copyfiles.m`: copies multiple files (MATLAB's copyfile wrapper) <br />
  - `ctime.m`: creates string with current date-time (yyyymmdd_hhmmss[fff]) <br />
  - `dirtree.m`: displays directory tree in the command line <br />
  - `dispcmd.m`: human-readable display long dash argument-value command strings <br />
  - `dispstrcell.m`: generate matlab code to re-create cell of strings variable <br />
  - `driveinpath.m`: extracts drive substring from absolute filepath <br />
  - `dropbox.m`: retrieves path of main dropbox folder <br />
  - `dropboxfix.m`: ensure dropbox substring in preloaded paths matches current machine <br />
  - `ensurecolumnvector.m`: ensure input is a column vector (transpose if needed) <br />
  - `ensuredrive.m`: ensure drive compatible with desired platform <br />
  - `ensurerowstring.m`: ensure row string (i.e. readable) (transpose if needed) <br />
  - `exist2.m`: exist.m wrapper (common types + automatic error generation) <br />
  - `fdir.m`: custom dir function <br />
  - `fdirrec.m`: list sub-directories and files within them ([rec]ursive fdir.m) <br />
  - `fileparts2.m`: extends fileparts.m <br />
  - `filesep2.m`: extends filesep.m (user can specify platform) <br />
  - `filesepfix.m`: ensure input paths have separator suitable for a given system <br />
  - `findsubim.m`: find region (sub-image) of image with max/min mean intensity <br />
  - `folderinpath.m`: extracts folder from a full file path <br />
  - `fsl2m.m`: converts 3D coordinates from FSL to MATLAB formats <br />
  - `fxdoc.m`: prints function documentation template to command window <br />
  - `getabovedir.m`: returns path of directories closer to the root <br />
  - `imori.m`: change image volume orientation <br />
  - `is1d.m`: check if input is 1D "vector" <br />
  - `isallequal.m`: checks if all elements in the array are equal <br />
  - `isext.m`: check if file matches extension(s) <br />
  - `isint.m`: checks if the input is an integer <br />
  - `iswinpath.m`: checks if input path is from a file in a windows filesystem <br />
  - `json2struct.m`: load .json file into MATLAB struct <br />
  - `jsonreformat.m`: reformats .json string to human-readable format <br />
  - `loadfilelines.m`: load each line of a given file into a cell element <br />
  - `logic2str.m`: converts logical scalar to string <br />
  - `lsfile.m`: list files in dir and pick according to file # index <br />
  - `m2fsl.m`: converts 3D coordinates from MATLAB to FSL formats <br />
  - `m2sharr.m`: convert cell of strings to space-delimited list (like bash arrays) <br />
  - `matinfo.m`: info struct to attach to any automatically generated .mat file <br />
  - `matrix2string.m`: converts 2D matrix to text (figure displaying purposes) <br />
  - `mkdirf.m`: extends mkdir.m function (automatic name/overwrite control) <br />
  - `mkdirtmp.m`: make directory in Temp files <br />
  - `movefiles.m`: moves multiple files (MATLAB's movefile wrapper) <br />
  - `msmidnight2hhmmssfff.m`: convert milisseconds since midnight to hh:mm:ss:fff <br />
  - `mtools.m`: displays index of functions in mtools in the command window <br />
  - `nameinpath.m`: isolates name of file(s) from its complete path(s) <br />
  - `nvargins2struct.m`: converts cell of argins (name-value pairs) into a struct <br />
  - `outinit`: output path default initialisation <br />
  - `pckillcmd.m`: kills "cmd.exe" processes on Windows machines <br />
  - `reparrew.m`: replicate array (element-wise) <br />
  - `scriptdoc.m`: prints script documentation template to command window <br />
  - `sortstruct.m`: sorts struct according to one of its fields <br />
  - `squeezext.m`: extends squeeze.m (specify singleton dimensions keep/remove) <br />
  - `strpad.m`: pad string with spaces to achieve a certain length <br />
  - `struct2json.m`: convert MATLAB struct into .json file <br /> 
  - `system2`: system.m wrapper. If in Windows: redirects cmd.exe commands to bash <br />
  - `sumn.m`: sum of array elements along multiple dimensions (sum in a loop) <br />
  - `targz.m`: convert list of files into .tar.gz archive <br />
  - `textheading.m`: creates a text heading/separator string for documentation <br />
  - `uniquecols.m`: find unique columns in 2D matrix and their row indexes <br />
  - `uniquesubstr.m`: remove duplicate substrings from string <br />
  - `vec2str.m`: converts a 1D-vector to a string <br />
  - `win2wsl.m`: convert Windows path(s) to Windows Subsystem for Linux (WSL) equivalent <br />
  - `wsl2win.m`: convert Windows Subsystem for Linux (WSL) path(s) to Windows equivalent <br />
  - `yyyymmdddiff.m`: difference (days) between two dates of format 'yyyymmdd' <br />
  - `yyyymmddfind.m`: finds and extracts date substrings of format 'yyyymmdd' <br />
- **[nii]**
  - `isnifti.m`: lazy NIfTI file path checker <br />
  - `niicrop.m`: FSL's fslroi MATLAB wrapper <br />
  - `niidotmask.m`: process NIfTI 'dotmask' file <br />
  - `niijsonvals.m`: get values from specific fields from .json sidecar <br />
  - `niiloadim.m`: load NIfTI image volume and fix orientation <br />
  - `niiloadimn.m`: load multiple 2D or 3D NIfTI images into a single 4D matrix <br />
  - `niimakeblank.m`: create NIfTI image of zeros using existing NIfTI image <br />
  - `niimaskmerge.m`: merge non-overlapping 3D masks into a single 3D mask file <br />
  - `niimaskrep.m`: replace nii voxels with those from other nii in mask ROIs <br />
  - `niimaskrepn.m`: niimaskrep.m wrapper for the case of multiple source images <br />

External code
-------------

Some of the functions in the above list use code written by others, which I typically get from [MATLAB's File Exchange](mathworks.com/matlabcentral/fileexchange/) or other GitHub repositories. For simplicity, where possible copies of such code are incorporated in this repository (`ext` folder), each function in its specific subdirectory. Attribution and licenses are included therewith whenever possible. A summary of the external code included in this repository is as follows:

### External code index
- `[jsonlab]`: a toolbox to encode/decode JSON files
  - Copyright (c) 2017, Qianqian Fang
  - Retrieved from [FEX-JSONlab](https://uk.mathworks.com/matlabcentral/fileexchange/33381-jsonlab--a-toolbox-to-encode-decode-json-files) on 20170325
- `[NIfTI_20140122]`: "Tools for NIfTI and ANALYZE image"
  - Copyright (c) 2014, Jimmy Shen
  - Retrieved from [FEX-8797-tools-for-nifti-and-analyze-image](https://uk.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image) on 20180301
- `progressbar.m`: simple, efficient, and user friendly replacement for waitbar
  - Copyright (c) 2005, Steve Hoelzer
  - Retrieved from [FEX-progressbar](https://uk.mathworks.com/matlabcentral/fileexchange/6922-progressbar) on 20170324

In addition, some of my functions may incorporate code snippets from others. This will be detailed in the documentation of each function.

Additional dependencies
-----------------------

  - `niicrop.m` requires FSL (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki) to be installed

___
___

Copyright (c) 2018, Fabio Nery <br />
All rights reserved. <br />

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

- Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
- Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
