(setq display-buffer-alist
      '(("\*Compilation\*"
         (display-buffer-reuse-window
          display-buffer-in-side-window)
         (side . right)
         (slot . -1)
         (window-width . 0.3))
        ("\*Messages\*"
         (display-buffer-reuse-window
          display-buffer-in-side-window)
         (side . right)
         (slot . -2)
         (window-width . 0.3))
        ("\*Output\*"
         (display-buffer-reuse-window
          display-buffer-in-side-window)
         (side . right)
         (slot . -3)
         (window-width . 0.3))
        ))
