# try
cgffffffffffffffffffffffffffcif git diff --name-only HEAD^..HEAD | grep -q '^directory1/'; then
            echo "Directory 1 has changes"
            echo "::set-output name=directory::directory1"
          else
            echo "No changes in Directory 1"
            exit 0
          fi
