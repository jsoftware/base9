NB. build

dat=. readsourcex_jp_ '~Main/main'
dat=. dat,freads '~Main/main/break.ijs'
ver=. (' ',CRLF) -.~ fread '~Main/config/version.txt'
dat=. dat rplc 'JLIBVERSION';ver
dat fwritenew '~Main/release/main.ijs'
