# The shell program /bin/bash (hereafter referred to as “the shell”) uses a collection of startup files to help create an environment to run in. Each file has a specific use and may affect login and interactive environments differently. The files in the /etc directory provide global settings. If an equivalent file exists in the home directory, it may override the global settings.

# An interactive login shell is started after a successful login, using /bin/login, by reading the /etc/passwd file. An interactive non-login shell is started at the command-line (e.g., [prompt]$/bin/bash). A non-interactive shell is usually present when a shell script is running. It is non-interactive because it is processing a script and not waiting for user input between commands.

# For more information, see info bash under the Bash Startup Files and Interactive Shells section.

# The files /etc/profile and ~/.bash_profile are read when the shell is invoked as an interactive login shell.

# The base /etc/profile below sets some environment variables necessary for native language support. Setting them properly results in:

# The output of programs translated into the native language

# Correct classification of characters into letters, digits and other classes. This is necessary for bash to properly accept non-ASCII characters in command lines in non-English locales

# The correct alphabetical sorting order for the country

# Appropriate default paper size

# Correct formatting of monetary, time, and date values

# Replace <ll> below with the two-letter code for the desired language (e.g., “en”) and <CC> with the two-letter code for the appropriate country (e.g., “GB”). <charmap> should be replaced with the canonical charmap for your chosen locale. Optional modifiers such as “@euro” may also be present.

# The list of all locales supported by Glibc can be obtained by running the following command:

locale -a
# Charmaps can have a number of aliases, e.g., “ISO-8859-1” is also referred to as “iso8859-1” and “iso88591”. Some applications cannot handle the various synonyms correctly (e.g., require that “UTF-8” is written as “UTF-8”, not “utf8”), so it is safest in most cases to choose the canonical name for a particular locale. To determine the canonical name, run the following command, where <locale name> is the output given by locale -a for your preferred locale (“en_GB.iso88591” in our example).

LC_ALL=<locale name> locale charmap
# For the “en_GB.iso88591” locale, the above command will print:

ISO-8859-1
# This results in a final locale setting of “en_GB.ISO-8859-1”. It is important that the locale found using the heuristic above is tested prior to it being added to the Bash startup files:

LC_ALL=<locale name> locale language
LC_ALL=<locale name> locale charmap
LC_ALL=<locale name> locale int_curr_symbol
LC_ALL=<locale name> locale int_prefix
# The above commands should print the language name, the character encoding used by the locale, the local currency, and the prefix to dial before the telephone number in order to get into the country. If any of the commands above fail with a message similar to the one shown below, this means that your locale was either not installed in Chapter 6 or is not supported by the default installation of Glibc.

# locale: Cannot set LC_* to default locale: No such file or directory
# If this happens, you should either install the desired locale using the localedef command, or consider choosing a different locale. Further instructions assume that there are no such error messages from Glibc.

# Some packages beyond LFS may also lack support for your chosen locale. One example is the X library (part of the X Window System), which outputs the following error message if the locale does not exactly match one of the character map names in its internal files:

# Warning: locale not supported by Xlib, locale set to C
# In several cases Xlib expects that the character map will be listed in uppercase notation with canonical dashes. For instance, "ISO-8859-1" rather than "iso88591". It is also possible to find an appropriate specification by removing the charmap part of the locale specification. This can be checked by running the locale charmap command in both locales. For example, one would have to change "de_DE.ISO-8859-15@euro" to "de_DE@euro" in order to get this locale recognized by Xlib.

# Other packages can also function incorrectly (but may not necessarily display any error messages) if the locale name does not meet their expectations. In those cases, investigating how other Linux distributions support your locale might provide some useful information.

# Once the proper locale settings have been determined, create the /etc/profile file:

cat > /etc/profile << "EOF"
# Begin /etc/profile

export LANG=<ll>_<CC>.<charmap><@modifiers>

# End /etc/profile
EOF
# The “C” (default) and “en_US” (the recommended one for United States English users) locales are different. “C” uses the US-ASCII 7-bit character set, and treats bytes with the high bit set as invalid characters. That's why, e.g., the ls command substitutes them with question marks in that locale. Also, an attempt to send mail with such characters from Mutt or Pine results in non-RFC-conforming messages being sent (the charset in the outgoing mail is indicated as “unknown 8-bit”). So you can use the “C” locale only if you are sure that you will never need 8-bit characters.

# UTF-8 based locales are not supported well by some programs. Work is in progress to document and, if possible, fix such problems, see http://www.linuxfromscratch.org/blfs/view/8.3/introduction/locale-issues.html.
