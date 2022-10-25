PLATFORM = $(shell uname)
ifneq ("$(wildcard /etc/os-release)","")
PLATFORM = $(shell . /etc/os-release && echo $$NAME)
endif

#override platform selection on RPi:
ifneq ("$(wildcard /opt/vc/include/bcm_host.h)","")
    PLATFORM = Raspbian GNU/Linux
endif


#	set the basic per-platform compile options
ifeq ($(PLATFORM),Raspbian GNU/Linux)
	CXX = g++

	CPPFLAGS := -Wall -g -std=c++11 -fPIC
	CPPFLAGS += -I./include/ -DISF_TARGET_RPI -DISF_TARGET_GLES
	#CPPFLAGS += -O3
	CPPFLAGS += -O0
	CPPFLAGS += -I$(SDKSTAGE)/opt/vc/include/
	CPPFLAGS += -I$(SDKSTAGE)/opt/vc/include/interface/vcos/pthreads
	CPPFLAGS += -I$(SDKSTAGE)/opt/vc/include/interface/vmcs_host/linux
	CPPFLAGS += -Wno-unknown-pragmas

	LDFLAGS := -lstdc++ -fPIC
	LDFLAGS += -L$(SDKSTAGE)/opt/vc/lib/
	LDFLAGS += -lGLESv2 -lEGL
	LDFLAGS += -lbcm_host -lpthread
else ifeq ($(shell uname),Linux)

else ifeq ($(PLATFORM),Darwin)
	CXX = clang
	CPPFLAGS := -Wall -g -arch x86_64 -O3 -std=c++11 -stdlib=libc++ -fPIC 
	CPPFLAGS += -DVVGL_SDK_GLFW
	OBJCPPFLAGS := $(CPPFLAGS)
	
	CPPFLAGS += -x c++
	OBJCPPFLAGS += -x objective-c++
	CPPFLAGS += -I/usr/local/Cellar/glfw/3.3.8/include
	CPPFLAGS += -I/usr/local/Cellar/glew/2.2.0_1/include
	LDFLAGS := -lstdc++ -lobjc -lglew -lglfw
	#LDFLAGS += -framework Cocoa -framework Foundation -framework CoreMedia -framework ImageIO -framework OpenGL -framework IOSurface -framework CoreGraphics -framework CoreVideo
	LDFLAGS += -framework OpenGL
endif


#	the GL_DEBUG flag enables a call to glGetError() after every call to GL
CPPFLAGS += -DGL_DEBUG
OBJCPPFLAGS += -DGL_DEBUG

# link against and include the VVISF library
LDFLAGS += -L./dep/VVISF/bin -lVVISF
CPPFLAGS += -I./dep/VVISF/include
OBJCPPFLAGS += -I./dep/VVISF/include
# link against and include the VVGL library
LDFLAGS += -L./dep/VVGL/bin -lVVGL
CPPFLAGS += -I./dep/VVGL/include
OBJCPPFLAGS += -I./dep/VVGL/include


#	rules that define object files for source files
OBJS := $(patsubst ./src/%.cpp,./obj/%.o,$(wildcard ./src/*.cpp))
ifeq ($(PLATFORM),Darwin)
OBJS += $(patsubst ./src/%.mm,./obj/%.mm.o,$(wildcard ./src/*.mm))
endif


#	targets are object files, recipe compiles them
ifeq ($(PLATFORM),Darwin)
./obj/%.mm.o : ./src/%.mm
	$(shell mkdir -p ./obj)
	$(CXX) $(OBJCPPFLAGS) -c $< -o $@
endif
./obj/%.o : ./src/%.cpp
	$(shell mkdir -p ./obj)
	$(CXX) $(CPPFLAGS) -c $< -o $@


#$(info Platform is $(PLATFORM))
#$(info OBJS are $(OBJS))
#$(info CPPFLAGS are $(CPPFLAGS))
#$(info LDFLAGS are $(LDFLAGS))


#	the output file is an executable
OUTPUT = ./bin/TestExecutable
#	recipe to create the dependencies, output file and the directory it goes in
$(OUTPUT) : $(OBJS)
	$(MAKE) -C ./dep/VVGL
	$(MAKE) -C ./dep/VVISF
	$(shell mkdir -p ./bin)
	$(CXX) $(OBJS) $(LDFLAGS) -o $@


#administrative targets
.PHONY : all clean clean_all

all : $(OUTPUT)

clean:
	rm -rf ./obj
	rm -rf ./bin

clean_all : clean
	$(MAKE) -C ./dep/VVISF clean_all
	$(MAKE) -C ./dep/VVGL clean_all






