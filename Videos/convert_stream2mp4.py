import os
import subprocess

Recurse = True
VideoStream = "0:0"
AudioStream = "0:1"
InputPath='/input/path/to/the/videos/2beConverted'
OutputPath='/output/path/to/store/the/mp4/videos'

def convert_video_2_mp4(input_filepath, output_filepath, video_stream, audio_stream):
    if os.path.exists(output_filepath):
        print("File " + output_filepath + " alread exists")
    else:
        command ='ffmpeg -i "'+ input_filepath +'" -f mp4 -map "' + video_stream + '" -map "' + audio_stream + '" -aspect 16:9 -c:v libx264 -c:a aac -c:s none "' + output_filepath + '"'
        p = subprocess.Popen(command, shell=True, stderr=subprocess.PIPE, stdout=subprocess.PIPE, universal_newlines=True)
        out, err = p.communicate()
        print(out)
        print(err)
        
def create_outputfilepath(output_path, input_filename):
    if not os.path.exists(output_path):
        os.makedirs(output_path)
    outputfilepath = os.path.join(output_path, (os.path.splitext(input_filename)[0] + '.mp4').replace(" ", "_"))
    return outputfilepath

if __name__ == "__main__":
    

    if Recurse is True:
        for root, folders, files in os.walk(InputPath):
            for video_file in files:
                if video_file.endswith(".mpg") or video_file.endswith(".ts") or video_file.endswith(".MOV") or video_file.endswith(".m2ts"):
                    outputfile = os.path.basename(root)
                    print("\n**************" + outputfile + "/" + video_file + "**************\n")
                    outputfile = os.path.join(OutputPath, outputfile.replace(" ", "_"))
                    outputfilepath = create_outputfilepath(outputfile, video_file)
                    convert_video_2_mp4(os.path.join(root,video_file), outputfilepath, VideoStream, AudioStream)
    else:
        for video_file in os.listdir(InputPath):
            video_filepath = os.path.join(InputPath, video_file)
            if os.path.isfile(video_filepath):
                 if video_file.endswith(".mpg") or video_file.endswith(".ts") or video_file.endswith(".MOV") or video_file.endswith(".m2ts"):
                    print("\n**************" + video_file + "**************\n")
                    outputfilepath = create_outputfilepath(OutputPath, video_file)
                    convert_video_2_mp4(video_filepath, outputfilepath, VideoStream, AudioStream)