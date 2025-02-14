% (The MIT License)
%
% Copyright (c) 2021 Yegor Bugayenko
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the 'Software'), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{slidedeck}[00.00.0000 0.0.0 Slide Deck]

\RequirePackage{../inno}

\RequirePackage{xcolor}
  \definecolor{sd-white}{HTML}{EEEEEE}
  \definecolor{sd-red}{HTML}{ED474A}
  \definecolor{sd-orange}{HTML}{F06543}
  \definecolor{sd-black}{HTML}{232527}
  \definecolor{sd-grey}{HTML}{C0BCB5}
  \definecolor{sd-green}{HTML}{5C946E}
  \definecolor{sd-blue}{HTML}{5299D3}
\RequirePackage{pagecolor}

\newif\ifwhite
\DeclareOption{white}{\whitetrue}
\newif\ifstatic
\DeclareOption{static}{\statictrue}
\ProcessOptions\relax

\LoadClass{article}
\RequirePackage{geometry}
  \geometry{paperwidth=16in, paperheight=9in, left=4in, right=2in, top=1.5in, bottom=1.5in}
\RequirePackage[tt=false,type1=true]{libertine}
\RequirePackage{microtype}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{multicol}
\RequirePackage{anyfontsize}
\RequirePackage{varwidth}
\RequirePackage{verbatim}
\RequirePackage[hidelinks]{hyperref}
\RequirePackage[inline]{enumitem}
\RequirePackage{ffcode}
\RequirePackage{multirow}
\RequirePackage{changepage}
\RequirePackage{tabularx}
\RequirePackage{amsmath}
\RequirePackage{graphicx}
\RequirePackage{qrcode}
\RequirePackage{soul}
\RequirePackage{tikz}
  \RequirePackage{tikzpagenodes}
  \usetikzlibrary{arrows}
  \usetikzlibrary{decorations}
  \usetikzlibrary{decorations.pathmorphing}
  \usetikzlibrary{intersections}
  \usetikzlibrary{positioning}
  \usetikzlibrary{backgrounds}
  \usetikzlibrary{calc}
  \usetikzlibrary{shapes.arrows}
\RequirePackage{lastpage}
\RequirePackage{etoolbox}
\RequirePackage[absolute]{textpos}
  \TPGrid{16}{16}
\RequirePackage{fancyhdr}
  \pagestyle{fancy}
  \renewcommand{\headrulewidth}{0pt}
  \fancyhf{}
  \fancyhead[L]{{
    \ifnum\value{page}=1\else%
      \ifx\sdCRUMBS\empty\else%
        \begin{textblock}{12}(1,1)%
          \small\ttfamily%
          \begin{enumerate*}[label={},labelindent=0pt]
            \sdCRUMBS
          \end{enumerate*}
          \expandafter\ifcsname sdSTOC\romannumeral\the\value{sdCRUMBScnt}\endcsname
            \expandafter\ifx\csname sdSTOC\romannumeral\the\value{sdCRUMBScnt}\endcsname\empty\else%
              \ifnum\value{sdCRUMBScnt}=0\else%
                \\[6pt]
                \quad\footnotesize\color{gray}%
                [\begin{enumerate*}[label={},labelindent=0pt]
                  \csname sdSTOC\romannumeral\the\value{sdCRUMBScnt}\endcsname{}
                \end{enumerate*}]
              \fi
            \fi
          \fi
        \end{textblock}%
      \fi
    \fi
  }}
  \fancyhead[R]{
    \ifnum\value{page}=1\else%
      \begin{textblock}{4}[1,0](15,1)%
        \ttfamily {\thepage{}}{\small{\color{sd-grey}/\pageref{LastPage}}}
      \end{textblock}%
      \ifstatic\else%
        \begin{textblock}{1}[1,0](15.8,0.2)%
          \tikz{\node[inner sep=2pt,circle,draw=sd-grey]{\color{sd-grey}\footnotesize\ttfamily\thesdMinutes{}};}
        \end{textblock}%
      \fi
    \fi
  }
  \fancyfoot[L]{
    \ifnum\value{page}=1\else%
      \begin{textblock}{8}[0,1](1,15)%
        {\color{sd-grey}\footnotesize\ttfamily \thetitle{} \thesubtitle{}}
      \end{textblock}%
    \fi
  }
  \fancyfoot[R]{
    \ifnum\value{page}=1\else%
      \begin{textblock}{8}[1,1](15,15)%
        {\color{sd-grey}\footnotesize\ttfamily \theauthor{}}
      \end{textblock}%
    \fi
  }

\newcommand*\sdBODY{}
\newcommand\sdFLUSH{\sdBODY\vspace*{0pt}\newpage}
\newcommand\sdFlush[1][1]{\sdFLUSH\renewcommand*\sdBODY{}\sdMins{#1}}
\newcommand\sdClick{\ifstatic\else\sdFLUSH\fi}

\newcommand\br{\newline}

\newcommand\sdMiddle[1]{\vspace*{\fill}#1\vspace*{\fill}}

\newcommand\sdTitle[2]{
  {\sdBanner{\Huge #1}}
  {\sdBanner{\large #2}}
}

% see https://tex.stackexchange.com/a/12414/1449
\RequirePackage{catchfile}
  \newwrite\appendwrite
  \newcommand*\appendtofile[2]{%
      \begingroup
      \IfFileExists{#1}%
        {\CatchFileDef{\filecontent}{#1}{\endlinechar=`^^J\catcode\endlinechar=12\relax}}% keep existing end-of-lines
        {\let\filecontent\empty}%
      \immediate\openout\appendwrite=#1\relax
      \immediate\write\appendwrite{\unexpanded\expandafter{\filecontent} #2}%
      \immediate\closeout\appendwrite
      \endgroup
  }
\newcommand\sdTocPrint{
  \IfFileExists{\jobname.toc}{\input{\jobname.toc}}{\sdPrint{Table of Contents}}
  \IfFileExists{\jobname.crumbs}{\input{\jobname.crumbs}}{}
  \sdFlush[1]
}
\makeatletter\newcommand\back{\@backslashchar}\makeatother
\newcommand\sdToc[2]{
  \stepcounter{sdCRUMBScnt}
  \setcounter{sdSTOCcnt}{0}
  \ifx\sdTOC\empty
    \ifnum\value{sdCRUMBScnt}=1\else%
      \appendtofile{\jobname.toc}{\back sdClick}
    \fi
    \appendtofile{\jobname.toc}{\back sdTOCITEM{#2}}
  \fi
  \ifx\sdCRUMBS\empty
    \appendtofile{\jobname.crumbs}{\back sdCRUMBSITEM{#1}}
  \fi
  \sdPrintAndFlush{
    \sdMiddle{%
      {\ttfamily Chapter \#\thesdCRUMBScnt:}
      \sdBanner[blue]{\Large #2}
    }
  }
}
\newcommand*\sdTOC{}
\newcommand\sdTOCITEM[1]{
  \ifx\sdTOC\empty
    \gappto\sdBODY{
      \tikz{
        \node (z) {
          \begin{varwidth}{\textwidth}
            \begin{itemize}[label={}]
              \sdTOC
            \end{itemize}
          \end{varwidth}
        };
        \path [draw=sd-blue,line width=4pt] (z.north west) -- (z.south west);
      }
    }
  \fi
  \gappto\sdTOC{\item #1}
}
\newcommand*\sdCRUMBS{}
\newcounter{sdCRUMBScnt}
\newcommand\sdCRUMBSITEM[1]{
  \gappto\sdCRUMBS{
    \item \ifnum\value{enumi}=\value{sdCRUMBScnt}
      {\setulcolor{sd-blue}\color{sd-blue}\ul{#1}}
    \else
      #1
    \fi
  }
}

\newcounter{sdSTOCcnt}
\newcommand\sdStoc[1]{
  \stepcounter{sdSTOCcnt}
  \ifx\sdTOC\empty
    \appendtofile{\jobname.toc}{\back sdSTOC{\the\value{sdCRUMBScnt}}{#1}}
  \fi
}
\newcommand\sdSTOC[2]{
  \ifcsname sdSTOC\romannumeral#1\endcsname\else
    \expandafter\newcommand\expandafter*\csname sdSTOC\romannumeral#1\endcsname{}
  \fi
  \expandafter\gappto\csname sdSTOC\romannumeral#1\endcsname{
    \item \ifnum\value{enumi}=\value{sdSTOCcnt}
      {\setulcolor{sd-blue}\color{sd-blue}\ul{#2}}
    \else
      #2
    \fi
  }
}

\newcommand\sdBanner[2][green]{
  \par
  {\setlength{\fboxsep}{6pt}\colorbox{sd-#1}{\color{sd-white} #2}}
  \par
}

\newcommand\sdPic[2]{
  {%
    \setlength{\fboxsep}{0pt}%
    \setlength{\fboxrule}{1pt}%
    \fcolorbox{sd-grey}{sd-white}{%
      \includegraphics[width=#1\columnwidth]{#2}%
    }%
  }
}

\newcommand\sdQR[2][2in]{
  \tikz{%
    \node[draw=sd-white]{%
      \href{#2}{%
        \qrcode[height=#1]{#2}%
      }%
    }%
  }
}

\newcommand\sdPrint[1]{
  \gappto\sdBODY{{
    #1
    \par
  }}
}

% [1]: How many minutes to stay here
% [1]: The content to print and flush
\newcommand\sdPrintAndFlush[2][1]{
  \sdPrint{#2}\sdFlush[#1]
}

\newcommand\sdCite[3]{
  \begin{tabularx}{\columnwidth}{c>{\raggedright\arraybackslash}X}
    \raisebox{\dimexpr-\height+\ht\strutbox}{\sdPic{0.25}{../images/books/#1}}
    &
    ``#2''
    \def\param{#3}%
    \ifx\param\empty\else
      \newline\newline
      \small
      --- #3
    \fi
    \\
  \end{tabularx}
}

\newcommand\sdQuote[3]{\sdCite{../people/#1}{#2}{#3}}

% How many minutes more we spend
\newcommand\sdMins[1]{
  \addtocounter{sdMinutes}{#1}
}
\newcounter{sdMinutes}

\newcommand\sdSnippet[2][]{
  \begin{samepage}
    \small #1\verbatiminput{#2}
  \end{samepage}
}

\newcommand\sdPin[1]{%
  \begin{tikzpicture}[remember picture,overlay]%
    \node[anchor=north east] at (current page text area.north east) {%
      \begin{minipage}{\textwidth}%
        \raggedleft{#1}%
      \end{minipage}%
    };%
  \end{tikzpicture}%
}

\newcommand\nospell[1]{#1}

\renewcommand\normalsize{\fontsize{28pt}{32pt}\selectfont}
\renewcommand\small{\fontsize{22pt}{24pt}\selectfont}
\renewcommand\footnotesize{\fontsize{16pt}{20pt}\selectfont}
\renewcommand\large{\fontsize{32pt}{36pt}\selectfont}
\renewcommand\Large{\fontsize{42pt}{42pt}\selectfont}
\renewcommand\LARGE{\fontsize{52pt}{56pt}\selectfont}
\renewcommand\Huge{\fontsize{92pt}{104pt}\selectfont}

\newcommand*\theauthor{@yegor256}

\AtBeginDocument{%
  \ifwhite\else
    \pagecolor{sd-black}
    \color{sd-white}
  \fi
  \raggedbottom%
  \raggedright%
  \raggedcolumns%
  \setlength\topskip{0pt}%
  \setlength\headheight{32pt}%
  \setlength\footskip{32pt}%
  \setlength\parindent{0pt}%
  \setlength\parskip{18pt}%
  \setlength\columnsep{32pt}%
  \normalsize
}

\endinput