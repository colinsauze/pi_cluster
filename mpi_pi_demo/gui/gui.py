import subprocess
import os
import glob
from kivy.app import App
from kivy.uix.widget import Widget
from kivy.clock import Clock
from kivy.core.window import Window

class GUIWidget(Widget):
    def button_handler(self):
        num_points = self.ids["number_of_points_slider"].value
        print("number of points",str(int(num_points)))

        num_tasks = self.ids["number_of_cores_slider"].value
        print("number of jobs",str(int(num_tasks)))
        #launch a batch job
        output = subprocess.check_output(["sbatch", "-n",str(int(num_tasks)),"../mpi_numpi.sh",(str(int(num_points)))])
        print(output)
        #should say "Submitted batch job <jobid>"
        jobid=int(output.decode('UTF-8').split(" ")[3].strip())
        self.ids["message_label"].text = "Messages:\n\nSubmitted job "+str(jobid)

    def update_queue(self, interval):
        #get/display the job queue
        output = subprocess.check_output(["squeue","--format=\"%5i %20j %3t %5M %25N\""])
        self.ids["queue_label"].text = "Job Queue:\n\n" + output.decode('UTF-8').replace('"','')

        #get/display the output from the last command
        files = glob.glob("Job *")   
        files.sort(key=os.path.getmtime, reverse=True)

        file_count = len(files)

        if file_count >3:
            file_count = 3

        output = "Program Output:\n\n"
        for i in range(file_count-1,-1,-1):
            output = output + files[i] + "\n"
            f = open(files[i], 'r')
            output = output + f.read()
            f.close()

        self.ids["output_label"].text = output

class GUIApp(App):
    def build(self):
        self.title = "Super Computer Job Control"
        Window.size = ( 1024, 768)
        widget = GUIWidget()
        Clock.schedule_interval(widget.update_queue, 1)
        return widget

if __name__ == '__main__':
    GUIApp().run()
