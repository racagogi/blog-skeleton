<!--
Add here global page variables to use throughout your website.
-->
+++
mintoclevel = 2

# Add here files or directories that should be ignored by Franklin, otherwise
# these files might be copied and, if markdown, processed by Franklin which
# you might not want. Indicate directories by ending the name with a `/`.
# Base files such as LICENSE.md and README.md are ignored by default.
ignore = ["node_modules/","temp/","README.md"]
# RSS (the website_{title, descr, url} must be defined to get RSS)
prepath = ""
date_format = "yyyy mm dd"
+++

<!--
Add here global latex commands to use throughout your pages.
-->
\newcommand{\collaps}[2]{
~~~<button type="button" class="collapsible">~~~ #1 ~~~</button><div class="collapsiblecontent">~~~ #2 ~~~</div>~~~
}

\newcommand{\def}[3]{
@@def \label{#1} @@head **!#1** *!#2* @@ @@body #3 @@ @@
}

\newcommand{\link}[1]{
@@def-link [#1](/glossary/#!#1) @@
}

\newcommand{\note}[1]{@@note @@head 📑 **Note**@@ @@body #1 @@ @@}
\newcommand{\warn}[1]{@@warning @@head ⚠ **Warning!**@@ @@body #1 @@ @@}
