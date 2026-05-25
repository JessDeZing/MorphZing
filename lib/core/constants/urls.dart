// ignore_for_file: constant_identifier_names

const BASE_URL = "https://api.morphzing.com/api/v1";
//local baseURL (Hassan)
// const BASE_URL = "http://192.168.0.212:8000/api/v1";

const BASE_URL_STAGING = "https://api.morphzing.jafton.com/api/v1";

//registration
const USER_AUTH = "/user/authorize/";
const USER_VERIFY = "/user/verify/";
const USER_PHONE_UPDATE = "/user/update-phone/";
const USER_INFO = "/user/user_info";
const SUB_EXP = "/subscription/expire";
const USER_UPDATE = "/user/update/";
const USER_UPDATE_PASSWORD = "/user/update_password/";
const USER_RESET_PASSWORD = "/user/reset-password/";
const USER_CHECK_PASSWORD = "/user/check_password/";
const USER_DELETE = "/user/delete/";
const USER_SIGNUP = "/user/signup/";
const USER_SIGNUP_SOCIALS = "/user/signup/social/";
const USER_LOGIN = "/user/login/";
const USER_FORGOT_PASSWORD = "/user/forgot-password/";
const USER_LOGIN_FB = "/social/facebook/";
const USER_LOGIN_GOOGLE = "/social/google/";
const USER_LOGIN_APPLE = "/social/apple/";

//subscription
const USER_FREE_TRIAL = "/subscription/subscribe";
const FREE_PACKAGE = "/subscription/subscribe/free";



//journal
const JOURNAL_GET_JOURNEY = "/journal/journey/";
const JOURNAL_GET_STATS = "/journal/stats/";
const JOURNAL_GET_SINGLE_JOURNEY = "/journal/journey/";
const JOURNAL_PUT_SINGLE_JOURNEY = "/journal/journey/";
const JOURNAL_PATCH_SINGLE_JOURNEY = "/journal/journey/";
const JOURNAL_POST_JOURNEY = "/journal/journey/";
const ALL_JOURNAL_POST_JOURNEY = "/journal/journey_list/";
const JOURNAL_PUT_JOURNEY = "/journal/journey/{id}";
const JOURNAL_DELETE_JOURNEY = "/journal/journey/";
const JOURNAL_TEMPLATE = "/journal/journey/";
const JOURNAL_DELETE_PHOTO = "/journal/delete_photos/";

const JOURNAL_GET_JOURNEY_FOLDER = "/journal/journey/folder/";
const JOURNAL_GET_JOURNEY_SINGLE_FOLDER = "/journal/journey/folder/";
const JOURNAL_POST_JOURNEY_FOLDER = "/journal/journey/folder/";
const JOURNAL_PUT_JOURNEY_SINGLE_FOLDER = "/journal/journey/folder/";
const JOURNAL_PATCH_JOURNEY_SINGLE_FOLDER = "/journal/journey/folder/";
const JOURNAL_GET_JOURNEY_NOTE = "/journal/journey/note/";
const JOURNAL_POST_JOURNEY_NOTE = "/journal/journey/note/";
const JOURNAL_GET_JOURNEY_SINGLE_NOTE = "/journal/journey/note/";
const JOURNAL_PUT_JOURNEY_SINGLE_NOTE = "/journal/journey/note/";
const JOURNAL_PATCH_JOURNEY_SINGLE_NOTE = "/journal/journey/note/";

//about app
const FAQ_GET = "/agenda/faq_user/";
const PRIVACY_POLICY_GET = "/agenda/privacy_user/";
const TERMS_GET = "/agenda/terms_user/";
const DISCLAIMER = "/agenda/disclaimer_user/";

//templates
const GET_TEMPLATES = '/journal/premium-templates/';
const PURCHASE_TEMPLATE = '/journal/user-templates/';
const FREE_TEMPLATES = '/journal/free_templates_list/';

//notification
const GET_NOTIFICATION = '/journal/notifications/';
const SET_NOTIFICATION = '/journal/notifications/{id}/';

/// note
const NOTE_LIST = "/journal/note/";
const FOLDER_LIST = "/journal/folder/";
const MOVE_FOLDER = "/journal/move_to_folder/";
const REMOVE_FROM_FOLDER = "/journal/remove_from_folder/";
