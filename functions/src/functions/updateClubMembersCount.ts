/* eslint-disable max-len */
import * as functions from "firebase-functions/v2";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";

export const updateClubMembersCount = functions.firestore
  .onDocumentCreated("MEMBERS/{docId}", async (e) => {
    const change = e.data;
    if (!change) return;

    const member = change.data();
    if (!member || !member.clubId) return;

    const firestore = admin.firestore();

    try {
      // Count all members with the same clubId
      const membersSnapshot = await firestore
        .collection("MEMBERS")
        .where("clubId", "==", member.clubId)
        .get();

      const count = membersSnapshot.size;

      // Find the club document with matching clubId
      const clubsSnapshot = await firestore
        .collection("CLUBS")
        .where("id", "==", member.clubId)
        .limit(1)
        .get();

      if (clubsSnapshot.empty) {
        logger.warn(`No club found with clubId ${member.clubId}`);
        return;
      }

      // Update the club's membersCount field
      await clubsSnapshot.docs[0].ref.update({membersCount: count});

      logger.log(`Updated club ${member.clubId} with membersCount: ${count}`);
    } catch (error) {
      logger.error(`Error updating membersCount for clubId ${member.clubId}:`, error);
      throw error;
    }
  });
