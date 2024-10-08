# Simple example how to use ISF with GLFW
Based on examples from
- https://isf.video/developers
- https://github.com/mrRay/vvisf-gl
- https://github.com/Vidvox/ISF-Files

# VVGL / VVISF library documentation
- https://www.vidvox.net/rays_oddsnends/VVGLVVISF_Docs/GLFW/html/modules.html

Tested on OSX 12.6

# Linux:
- Tested on Linux(Arch) with glew 2.2.0-7, libglvnd 1.7.0-1, glfw 3.4-2, gcc 14.2.1
- using sway/wayland wayland 1.23.1-1, sway 1:1.9-5
to compile and run:
```
git clone <this repo> && cd <this repo>
git submodule update --init
make
cd bin
./TestExecutable
```

# GLEW & GLFW
see https://www.reddit.com/r/gamedev/comments/45v9uz/comment/d00jsgz/?utm_source=share&utm_medium=web2x&context=3

# Dependencies:
- glfw
  - https://github.com/glfw/glfw
  - https://formulae.brew.sh/formula/glfw
- glew
  - https://github.com/nigels-com/glew
  - https://formulae.brew.sh/formula/glew#default
