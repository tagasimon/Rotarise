/* eslint-disable max-len */
import * as functions from "firebase-functions/v2";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";

export const updatePostViewCount = functions.firestore
  .onDocumentWritten("POST_VIEWS/{docId}", async (event) => {
    const firestore = admin.firestore();

    const beforeData = event.data?.before?.data();
    const afterData = event.data?.after?.data();

    if (!beforeData && !afterData) return;

    const isCreated = !beforeData && !!afterData;
    const isDeleted = !!beforeData && !afterData;

    const postId = afterData?.postId || beforeData?.postId;

    if (!postId) {
      logger.warn("Missing postId in post view document.");
      return;
    }

    try {
      // Query for the post using `postId` field
      const snapshot = await firestore
        .collection("POSTS")
        .where("id", "==", postId)
        .limit(1)
        .get();

      if (snapshot.empty) {
        logger.warn(`Post with postId ${postId} not found.`);
        return;
      }

      const postDocRef = snapshot.docs[0].ref;

      await firestore.runTransaction(async (tx) => {
        const postDoc = await tx.get(postDocRef);

        const currentCount = postDoc.data()?.viewCount || 0;
        let newCount = currentCount;

        if (isCreated) {
          newCount = currentCount + 1;
        } else if (isDeleted) {
          newCount = Math.max(0, currentCount - 1);
        }

        tx.update(postDocRef, {viewCount: newCount});
      });

      logger.log(`Updated viewCount for post ${postId}`);
    } catch (error) {
      logger.error(`Error updating viewCount for post ${postId}:`, error);
      throw error;
    }
  });

