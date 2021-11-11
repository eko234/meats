(local db ((require :flat) "./db"))
(local L (require :lummander))

(fn iter->table [iter]
  (icollect [v iter] v ))

(fn disarray [map]
  (icollect [k {: x : y : file : hot} (pairs map)]
            {:entry (string.format "%s:%s:%s:%s" k file x y)
             :hot hot}))

(lambda flash []
  (let
    [disarrayed   (disarray db.meats)
     sorting_done (table.sort disarrayed (fn [a b] (> a.hot b.hot)))]
    (table.concat (icollect [i v (ipairs disarrayed)] (string.format "%s:%s" i v.entry)) "\n")))

(lambda eat []
  (set db.meats {})
  (db:save))

(lambda snatch_nth_key [ix]
  (. (icollect [k _ (pairs db.meats)] k) ix))

(lambda taste [file]
  (tset db :meats file nil)
  (db:save))

(lambda lick [key]
  (tset db :meats key :hot (os.time))
  (db:save)
  (string.format "%s" (. (. db.meats key) :file)))

(lambda stab [k file x y hot]
  (tset db :meats k {: file : x : y : hot})
  (db:save))

(local cli
  (L.new {:title       :meats
          :tag         :meats
          :description "file + position store for text editors, make sure to have a db directory besides this boy"
          :theme       :acid }))

(-> cli
    (: :command "flash" "show your meat")
    (: :action (fn [parsed command app]
                 (let
                   [output (flash)]
                   (when output (print output))))))

(-> cli
    (: :command "eat" "empty the grill")
    (: :action (fn [parsed command app]
                 (eat))))

(-> cli
    (: :command "taste <meat>" "eat one up")
    (: :action (fn [parsed command app]
                 (let
                   [[file & maybe_more] (iter->table (string.gmatch parsed.meat "([^:]+)"))]
                   (taste file)))))

(-> cli
    (: :command "lick <meat>" "mmmmm")
    (: :action (fn [parsed command app]
                 (let
                   [[k_or_ix] (iter->table (string.gmatch parsed.meat "([^:]+)"))]
                   (if (string.match k_or_ix "%d")
                     (print (lick (snatch_nth_key (tonumber k_or_ix))))
                     (print (lick k_or_ix)))))))

(-> cli
    (: :command "stab <meat>" "streak a meat on top of the rest")
    (: :action (fn [parsed command app]
                 (let
                   [[k file x y] (iter->table (string.gmatch parsed.meat "([^:]+)"))]
                   (when (assert ( = (length k) 1 ))
                     (stab k file x y (os.time)))))))

(cli:parse arg)
