/* eslint-disable max-len */
import * as functions from "firebase-functions/v2";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";

export const updateClubEventsCount = functions.firestore
  .onDocumentCreated("EVENTS/{docId}", async (e) => {
    const change = e.data;
    if (!change) return;

    const event = change.data();
    if (!event || !event.clubId) return;

    const firestore = admin.firestore();

    try {
      // Count all events with this clubId
      const eventsSnapshot = await firestore
        .collection("EVENTS")
        .where("clubId", "==", event.clubId)
        .get();

      const count = eventsSnapshot.size;

      // Find the club document with matching clubId
      const clubsSnapshot = await firestore
        .collection("CLUBS")
        .where("id", "==", event.clubId)
        .limit(1)
        .get();

      if (clubsSnapshot.empty) {
        logger.warn(`No club found with clubId ${event.clubId}`);
        return;
      }

      // Update the club's eventsCount field
      await clubsSnapshot.docs[0].ref.update({eventsCount: count});

      logger.log(`Updated club ${event.clubId} with eventsCount: ${count}`);
    } catch (error) {
      logger.error(`Error updating eventsCount for clubId ${event.clubId}:`, error);
      throw error;
    }
  });
