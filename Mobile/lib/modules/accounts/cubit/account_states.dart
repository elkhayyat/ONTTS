abstract class AccountStates {}


class LoginInitialState extends AccountStates{}
class LoginLoadingState extends AccountStates{}
class LoginDoneState extends AccountStates{}
class LoginUnAuthorizedState extends AccountStates{}
class LoginErrorState extends AccountStates{}

class LogoutLoadingState extends AccountStates{}
class LogoutDoneState extends AccountStates{}
class LogoutErrorState extends AccountStates{}

class GetLoginStateLoadingState extends AccountStates{}
class GetLoginStateDoneState extends AccountStates{}
class GetLoginStateErrorState extends AccountStates{}

class GetUserDataLoadingState extends AccountStates{}
class GetUserDataDoneState extends AccountStates{}
class GetUserDataErrorState extends AccountStates{}

class TitleSetState extends AccountStates{}


class TimeStopLoadingState extends AccountStates{}
class TimeStopDoneState extends AccountStates{}
class TimeStopErrorState extends AccountStates{}

class TimeLoadingState extends AccountStates{}
class TimeDoneState extends AccountStates{}
class TimeErrorState extends AccountStates{}
