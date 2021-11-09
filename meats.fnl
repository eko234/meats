(local dba ((require :flat) "./db"))
(local dbb ((require :flat) "./db"))

; (each [ix val (ipairs dba.names)]
;   (print val))


(print dba.names.mile.name)
(print dba.names.mile.desc)

(tset dba :names :mile :name "still her")
(tset dbb :names :mile :desc "lets dable in here")

; (tset dba :names :mile {:name "Mile en efecto"
;                         :desc "now this is a struct"})

; (tset dbb :names :paca "Paca en efecto")

; (: dba :save)

