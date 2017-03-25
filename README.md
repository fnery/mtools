# mtools
Assorted MATLAB tools I use throughout my MATLAB code. I try to capture common tasks in MATLAB functions, in an attempt to keep my code clean and modular. Essentially I'm trying [not to repeat myself](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself). Hopefully, each one of these functions is self-contained and can be re-used in different scenarios. <br />
Feel free to do whatever to this code. If you spot any issues please let me know. If you would like to enlighten me with better ways to code any of this that would be really cool. <br />
Email me at: `regexprep({'fabio-nery-13_ucl-ac-uk'}, {'-','_'}, {'.','@'})`. <br />

mtools index:
-------------

- **[fig]**
  - `selectroi.m`: draw ROIs in the displayed image and create corresponding masks <br />
- **[misc]**
  - `authstr.m`: creates author string for function documentation <br />
  - `bwcircle.m`: Creates binary (logical) image with a 1-valued circle <br />
  - `cell2str.m`: converts [n x 1] cell of strings to a [n x nChars] string <br />
  - `cellstrmatch.m`: create new cell from matching(or not) strings in input cell <br />
  - `cleanstr.m`: replace spaces by underscores and remove non-alphanum chars <br />
  - `ctime.m`: creates string with current date-time (yyyymmdd_hhmmss[fff]) <br />
  - `dispstrcell.m`: generate matlab code to re-create cell of strings variable <br />
  - `fdir.m`: custom dir function <br />
  - `filepartscell.m`: extends matlab's fileparts for "cell of strings" inputs <br />
  - `fxdoc.m`: prints function documentation template to command window <br />
  - `getabovedir.m`: returns path of directories closer to the root <br />
  - `is1d.m`: check if input is 1D "vector" <br />
  - `isint.m`: checks if the input is an integer <br />
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

External code
-------------

Some of the functions in the above list use code written by others, which I typically get from [MATLAB's File Exchange](mathworks.com/matlabcentral/fileexchange/) or other GitHub repositories. For simplicity, copies of such code are incorporated in this repository (`ext` folder), each function in its specific subdirectory. Attribution and licenses are included whenever possible. A summary of the external code is as follows included in this repository is as follows:

### External code index

- [subdir]: Performs a recursive file search
  - Copyright (c) 2015 Kelly Kearney
  - Retrieved from [subdir-pkg](https://github.com/kakearney/subdir-pkg) on 20170324