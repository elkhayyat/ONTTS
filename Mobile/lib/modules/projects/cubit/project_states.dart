abstract class ProjectStates{}

class ProjectInitialState extends ProjectStates{}
class ProjectLoadingState extends ProjectStates{}
class ProjectDoneState extends ProjectStates{}
class ProjectErrorState extends ProjectStates{}

class ProjectTasksLoadingState extends ProjectStates{}
class ProjectTasksDoneState extends ProjectStates{}
class ProjectTasksErrorState extends ProjectStates{}

class TimeLoadingState extends ProjectStates{}
class TimeDoneState extends ProjectStates{}
class TimeErrorState extends ProjectStates{}

class TimeStartLoadingState extends ProjectStates{}
class TimeStartDoneState extends ProjectStates{}
class TimeStartErrorState extends ProjectStates{}

class TimeStopLoadingState extends ProjectStates{}
class TimeStopDoneState extends ProjectStates{}
class TimeStopErrorState extends ProjectStates{}

class DurationUpdateState extends ProjectStates{}
