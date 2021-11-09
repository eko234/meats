(local db ((require :flat) "./db"))
(local L (require :lummander))
(local view (require :fennel.view))

(fn iter->table [iter]
  (icollect [v iter] v ))

(fn disarray [map]
  (icollect [k v (pairs map)]
            {:entry (string.format "%s:%s:%s" k v.x v.y)
             :hot v.hot}))

(local cli
  (L.new {:title       :meats
          :tag         :meats
          :description "file + position store for text editors, make sure to have a db directory besides this boy"
          :theme       :acid }))

(-> cli
    (: :command "flash" "show your meat")
    (: :action (fn [parsed command app]
                 (let
                   [disarrayed   (disarray db.meats)
                    sorting_done (table.sort disarrayed (fn [a b] (> a.hot b.hot)))
                    [head & tail] disarrayed]
                   (print (.. (accumulate [acc head.entry
                                           ix el (ipairs tail)]
                                          (.. acc "\n" el.entry)) "\n"))))))

(-> cli
    (: :command "eat" "empty the grill")
    (: :action (fn [parsed command app]
                 (set db.meats {})
                 (db:save))))

(-> cli
    (: :command "taste <meat>" "eat one up")
    (: :action (fn [parsed command app]
                 (let
                   [[file & maybe_more] (iter->table (string.gmatch parsed.meat "([^:]+)"))]
                   (tset db :meats file nil)
                   (db:save)))))

(-> cli
    (: :command "stab <meat>" "streak a meat on top of the rest")
    (: :action (fn [parsed command app]
                 (let
                   [[file pos_x pos_y &as meat] (iter->table (string.gmatch parsed.meat "([^:]+)"))]
                   (tset db :meats file {:x pos_x :y pos_y :hot (os.time)})
                   (db:save)))))

(cli:parse arg)
