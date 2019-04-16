using System.Collections;
using System.Timers;
using UnityEngine;

/*
 * CCheckEscape permet de vérifier si l'utilisateur veut sortir de l'affichage des informations sur l'exoplanète
 * Une fois toutes les planètes visitées, cette classe permet aussi d'afficher la question de fin en changeant la caméra active
*/
public class CheckEscape : MonoBehaviour
{
    //Caméra de la scène d'informations en question
    public Camera           infoCam;
    //Caméra de la scène principale
    public Camera           mainCam;
    //Caméra de la scène de question de fin
    public Camera           endQuestionCam;
    //Caméra de la scène affichant Sweeps en résultat
    public Camera           endSweepsCam;
    //Caméra de la scène affichant Trappist en résultat
    public Camera           endTrappistCam;
    //Caméra de la scène affichant Wasp en résultat
    public Camera           endWaspCam;
    //Sprite de la porte, permettant de quitter la scène d'informations
    public SpriteRenderer   escape;
    //Scène d'affichage d'informations d'une exoplanete en question
    public ShowInfo         showInfo;

    //Création d'un compteur permettant d'enregistrer le nombre de frames passées à vouloir quitter la scène
    private int countEscape = 0;

    //Création d'une couleur de "découverte" afin de modifier la couleur de certains sprites par la suite
    Color discovered = new Color(1f, 1f, 1f, 1f);

    // Start is called before the first frame update
    void Start()
    {
        mainCam.enabled = false;
        infoCam.fieldOfView = 60;
    }

    // Update is called once per frame
    void Update()
    {
        //A chaque frame, nous verifions si l'utilisateur souhaite sortir de la scène d'informations
        CheckEsc();
        //A chaque frame, nous forcons la caméra passée en paramètre à rester avec un field of view compris entre 14 et 70 (pour la fonctionnalité de zoom)
        BoundFOV(infoCam, 14, 70);
    }

    //Fonction permettant de vérifier, à chaque frame, si l'utilisateur souhaite quitter la scène d'informations
    private void CheckEsc()
    {
        //Si l'angle de la caméra est compris entre 325 et 355 sur l'axe X (correspondant à la position du sprite de sortie) et
        //Si l'angle de la caméra est compris entre 195 et 215 sur l'axe Y (correspondant à la position du sprite de sortie) et
        //Si aucune des 4 caméras de fin n'est activée
        if (infoCam.transform.eulerAngles.x > 325 && infoCam.transform.eulerAngles.x < 355
            && infoCam.transform.eulerAngles.y > 195 && infoCam.transform.eulerAngles.y < 215
            && endSweepsCam.enabled == false && endTrappistCam.enabled == false && endWaspCam.enabled == false && endQuestionCam.enabled == false)
        {
            //A chaque frame, un compteur est incrémenté, pouvant alors fonctionner comme un chronomètre
            countEscape = countEscape + 1;

            //Si les conditions ci-dessus sont respectées pendant 15 frames
            if (countEscape == 15) {
                //Changement de la couleur du sprite de la porte en rouge, indiquant que la caméra est bien positionnée pour sortir
                escape.color = new Color(1f, 0f, 0f, 1f);
            }

            //Si les conditions ci-dessus sont respectées pendant 100 frames
            if (countEscape == 100) {
                //Désactivation de la caméra d'informations
                infoCam.enabled = false;
                //Activation de la caméra principale
                mainCam.enabled = true;
                //Modification du field of view de la caméra principale
                mainCam.fieldOfView = 18;

                //Changement de la couleur du sprite de la porte en blanc
                escape.color = new Color(1f, 1f, 1f, 1f);
                //Reinitialisation du compteur de frames
                countEscape = 0;
            }

            //Lorsque les différentes conditions ci-dessous sont réunies, l'utilisateur quitte la scène d'informations et ne revient pas comme précédemment sur la scène principale
            //mais sur la scène de fin permettant de choisir quelle est la planète qu'il trouve la plus étrange

            //Si la planete sweeps a été découverte (nom affiché) et
            //Si la planète trappist a été découverte (nom affiché) et
            //Si la planète wasp a été découvrte (nom affiché) et
            //30 frames sont passées avec la vue sur la porte de sortie alors
            if ((showInfo.sweeps_planet_11b_name.color == discovered)
            && (showInfo.trappist_planet_1e_name.color == discovered)
            && (showInfo.wasp_planet_12b_name.color == discovered)
            && countEscape == 30) {
                Debug.Log("ESCAPED");
                //Désactivation de la caméra principale
                mainCam.enabled = false;
                //Désactivation de la caméra d'informations
                infoCam.enabled = false;
                //Activation de la caméra de question de fin
                endQuestionCam.enabled = true;
                //Modification du field of view de la caméra de question de fin
                endQuestionCam.fieldOfView = 60;
            }
        }
        //Sinon
        else
        {   //Changement de la couleur du sprite de la porte en blanc
            escape.color = new Color(1f, 1f, 1f, 1f);
            //Reinitialisation du compteur de frames
            countEscape = 0;
        }
    }

//Fonction permettant de borner le field of view de la caméra passée en paramètres, afin de ne pas trop zoomer ou inversement
private void BoundFOV(Camera cam, int min, int max)
    {
        //Si le field of view tente de dépasser le seuil minimal
        if (cam.fieldOfView < min)
        {
            //Modification du field of view au seuil minimal
            cam.fieldOfView = min;
        }
        //Sinon si le field of view tente de dépasser le seuil maximal
        else if (cam.fieldOfView > max)
        {
            //Modification du field of vie au seuil maximal
            cam.fieldOfView = max;
        }
    }
}
