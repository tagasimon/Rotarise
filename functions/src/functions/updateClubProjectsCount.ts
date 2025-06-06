/* eslint-disable max-len */
import * as functions from "firebase-functions/v2";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";

export const updateClubProjectsCount = functions.firestore
  .onDocumentCreated("PROJECTS/{docId}", async (e) => {
    const change = e.data;
    if (!change) return;

    const project = change.data();
    if (!project || !project.clubId) return;

    const firestore = admin.firestore();

    try {
      // Count all projects with the same clubId
      const projectsSnapshot = await firestore
        .collection("PROJECTS")
        .where("clubId", "==", project.clubId)
        .get();

      const count = projectsSnapshot.size;

      // Find the club document with matching clubId
      const clubsSnapshot = await firestore
        .collection("CLUBS")
        .where("id", "==", project.clubId)
        .limit(1)
        .get();

      if (clubsSnapshot.empty) {
        logger.warn(`No club found with clubId ${project.clubId}`);
        return;
      }

      // Update the club's projectsCount field
      await clubsSnapshot.docs[0].ref.update({projectsCount: count});

      logger.log(`Updated club ${project.clubId} with projectsCount: ${count}`);
    } catch (error) {
      logger.error(`Error updating projectsCount for clubId ${project.clubId}:`, error);
      throw error;
    }
  });
