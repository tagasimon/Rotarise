/* eslint-disable max-len */
import {updatePostReportsAsSpamCount} from "./functions/updatePostReportsAsSpamCount";
import {updatePostLikesCount} from "./functions/updatePostLikesCount";
import {updatePostCommentsCount} from "./functions/updatePostCommentsCount";
/* eslint-disable max-len */
import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v2";
import {updateClubProjectsCount} from "./functions/updateClubProjectsCount";
import {updateClubEventsCount} from "./functions/updateClubEventsCount";
import {updateClubMembersCount} from "./functions/updateClubMembersCount";

admin.initializeApp();
// Set the maximum instances to 10 for all functions
functions.setGlobalOptions({maxInstances: 10});

export {
  updateClubProjectsCount,
  updateClubEventsCount,
  updateClubMembersCount,
  updatePostCommentsCount,
  updatePostLikesCount,
  updatePostReportsAsSpamCount,
};
