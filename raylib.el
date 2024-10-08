;; -*- lexical-binding: t; -*-

(load (concat "raylib.el" module-file-suffix))

;; Colors
(defconst rl-lightgray [200 200 200 255])
(defconst rl-gray [130 130 130 255])
(defconst rl-darkgray [80 80 80 255])
(defconst rl-yellow [253 249 0 255])
(defconst rl-gold [255 203 0 255])
(defconst rl-orange [255 161 0 255])
(defconst rl-pink [255 109 194 255])
(defconst rl-red [230 41 55 255])
(defconst rl-maroon [190 33 55 255])
(defconst rl-green [0 228 48 255])
(defconst rl-lime [0 158 47 255])
(defconst rl-darkgreen [0 117 44 255])
(defconst rl-skyblue [102 191 255 255])
(defconst rl-blue [0 121 241 255])
(defconst rl-darkblue [0 82 172 255])
(defconst rl-purple [200 122 255 255])
(defconst rl-violet [135 60 190 255])
(defconst rl-darkpurple [112 31 126 255])
(defconst rl-beige [211 176 131 255])
(defconst rl-brown [127 106 79 255])
(defconst rl-darkbrown [76 63 47 255])

(defconst rl-white [255 255 255 255])
(defconst rl-black [0 0 0 255])
(defconst rl-blank [0 0 0 0])
(defconst rl-magenta [255 0 255 255])
(defconst rl-raywhite [245 245 245 255])

;; Keys
(defconst rl-key-right 262)
(defconst rl-key-left 263)
(defconst rl-key-down 264)
(defconst rl-key-up 265)

;; non-raylib stuff
(defvar rl-dt (/ 1.0 60))
(defvar rl-mainloop-timer nil)

(declare-function rl-close-window  "raylib")
(declare-function rl-window-should-close  "raylib")

(defun rl-run-mainloop (function &optional fps)
  (when (timerp rl-mainloop-timer)
    (cancel-timer rl-mainloop-timer))

  (when fps
    (setq rl-dt (/ 1.0 fps)))

  (setq rl-mainloop-timer
        (run-at-time t rl-dt (lambda ()
                               (if (rl-window-should-close)
                                   (rl-stop-mainloop)
                                 (condition-case err (funcall function)
                                   (error (message "Caught signal: %s; Stopping main loop" err)
                                          (cancel-timer rl-mainloop-timer))))))))

(defun rl-stop-mainloop ()
  (interactive)
  (when (timerp rl-mainloop-timer)
    (cancel-timer rl-mainloop-timer))
  (setq rl-mainloop-timer nil)
  (rl-close-window))

(defun rl-v2 (x y)
  `[,x ,y])

(defmacro rl-x (v)
  `(aref ,v 0))

(defmacro rl-y (v)
  `(aref ,v 1))


(defun rl--debug-reload-module ()
  (let* ((module (concat "raylib.el" module-file-suffix))
        (tmpfile (make-temp-file (file-name-nondirectory module) nil module-file-suffix)))
    (message "Reloading raylib from temp file %s" tmpfile)
    (copy-file module tmpfile t)
    (module-load tmpfile)))

(provide 'raylib)
