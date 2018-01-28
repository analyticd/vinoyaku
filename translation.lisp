(in-package :vinoyaku)


(defgeneric translate (client text))

;;; Source: https://gist.github.com/longfanos/87fcf04579214424d2fe
;; var url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl="
;; + sourceLang + "&tl=" + targetLang + "&dt=t&q=" + encodeURI(sourceText);

(defparameter *source-language* "ja")
(defparameter *target-language* "en")

(defparameter *google-translate-api-address*
  (format nil "https://translation.googleapis.com/translate_a/single?client=gtx&sl=~A&tl=~A&dt=t&q="
          *source-language* *target-language*))

(defclass google-translate-client ()
  ((translate-addr :initform (format nil "~A"
                                     *google-translate-api-address*))))

(defmethod translate ((this google-translate-client) (text string))
  (with-slots (translate-addr headers) this
    (handler-case
        (let* ((answer (drakma:http-request (concatenate 'string translate-addr (drakma:url-encode text :utf-8))
                                            :method :get
                                            :content-type "application/json" ;; "text/html"
                                            :external-format-out :utf-8)))
          ;; TODO
          (jsown:val (jsown:parse answer ;; json
                                  ) "data"))
      (t (e) (log:error "Error during translation request: ~A" e) nil))))
