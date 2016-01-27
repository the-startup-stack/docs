tmux new-session -d -s docs
tmux split-window -t docs:1 -v
tmux split-window -t docs:1.2 -h
tmux rename-window main
tmux send-keys -t docs:1.1 "vim ." "Enter"
tmux send-keys -t docs:1.2 "bundle exec jekyll serve --drafts --trace" "Enter"
tmux send-keys -t docs:1.3 "browser-sync start --files \"_sass/*.scss\" --proxy \"localhost:4000\" --files \"_*/*.md\" --reloadDelay \"2000\"" "Enter"
tmux select-window -t docs:1
tmux attach -t docs
