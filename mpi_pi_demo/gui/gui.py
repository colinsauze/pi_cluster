import subprocess
from kivy.app import App
from kivy.uix.widget import Widget

class GUIWidget(Widget):
    def button_handler(self):
        print("button pressed")
        num_points = self.ids["number_of_points_slider"].value
        print("number of points",str(int(num_points)))
        #launch a batch job
        output = subprocess.check_output(["python3", "../mpi_numpi.py",(str(int(num_points)))])
        print(output)
        self.ids["message_label"].text = str(output.decode('UTF-8'))

        #grab the job number, add to a list of queued/running jobs
        #spawn a seperate thread to monitor the queue
        #display output of last few completed jobs

class GUIApp(App):
    def build(self):
        return GUIWidget()

if __name__ == '__main__':
    GUIApp().run()
