(vl-load-com)

;*********************************************************************************
;Creating Solid Hatches
(defun c:CPHATCH (/ a b e p)
  ;; RJP » 2019-01-30
  (while (setq p (getpoint "\nPick a point in a face: "))
    (setq a (entlast))
    (vl-cmdf "_.Solidedit" "_Face" "_Copy" p "" '(0 0 0) '(0 0 0) "" "")
    (cond ((eq a (setq e (entlast))) (print "Boundary not created.."))
	  ((/= "REGION" (cdr (assoc 0 (entget e)))) (entdel e) "Boundary created not valid..")
	  ((setq b (vlax-invoke (vlax-ename->vla-object e) 'explode))
	   (command "_.ucs" "_OB" (vlax-vla-object->ename (car b)))
	   (mapcar 'vla-delete b)
	   (command "_.bhatch" "_S" e "" "")
	   (entdel e)
	  )
    )
  )
  (princ)
)
;Switch Model and Paper.
(defun c:SSP ()
	(if (= (getvar "Tilemode") 0)(setvar "Tilemode" 1)(setvar "Tilemode" 0))
	(princ)
)
(defun c:cds (/ sty m na) ; Add New Dimension Style to user specified scaled factor
   (setvar "cmdecho" 0)
   (if (= (tblsearch "style" "dimtext") nil)
      (command "-style" "dimtext" "Arial" "0" "0.8" "" "" "" "")
   )
   (setvar "dimtmove" 0)
   (setvar "dimtix" 1)
   (setvar "dimupt" 0)
   (setvar "dimtoh" 0)
   (setvar "dimtih" 0)
   (setvar "dimaltrnd" 0.0000)
   (setvar "dimdec" 0)
   (setvar "dimadec" 0)
   (setvar "dimazin" 3)
   (setvar "dimzin" 12)
   (setvar "dimaunit" 0)
   (setvar "dimdsep" ".")
   (setvar "dimunit" 2)
   (setvar "dimasz" 3)
   (setvar "dimtxt" 3) 
   (setvar "dimclrt" 7) 
   (setvar "dimgap" 1)
   (setvar "dimtxsty" "dimtext") 
   (setvar "dimexe" 1)
   (setvar "dimexo" 1)
   (setvar "dimdli" 8)
   (setq sty (getint "\nName for new dimension style:"))
   (setq m (itoa sty))
   (setq na (strcat "S" m))
  (if (= (tblsearch "dimstyle" na) nil)
   (progn
   (setvar "dimscale" sty)
   (command "dimstyle" "s" na ))
   (progn
   (command "dimstyle" "r" na)
   (princ "\nTHE STYLE IS ALREADY IN USE !"))
  )   
  (setvar "cmdecho" 1)
   (princ)
)

(defun c:FC ( / s )
   (if (setq s (ssget))
       (command "_.ucs" "" "_.copybase" "_non" '(0 0 0) s "" "_.ucs" "_p")
   )
   (princ)
)
(defun c:FP nil
   (command "_.ucs" "" "_.pasteclip" "_non" '(0 0 0) "_.ucs" "_p")
   (princ)
)