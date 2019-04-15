using System.Collections;
using System.Timers;
using UnityEngine;

/*
 * ShowInfo est le script permettant de gérer le changement de caméra
 * afin d'afficher les informations sur les exoplanètes
 * ou de revenir sur la carte principale du ciel
*/

public class ShowInfo : MonoBehaviour
{
    // loupe est l'objet associé à la loupe et permet de gérer son mouvement
    public GameObject loupe;
    // liste des cameras utilisées en fonction des différentes scènes à afficher
    private Camera cam;
    public Camera mainCam;
    public Camera trappistCam;
    public Camera waspCam;
    public Camera sweepsCam;
    public Camera endSweepsCam;
    public Camera endTrappistCam;
    public Camera endWaspCam;
    public Camera endQuestionCam;

    // couleur des noms des exoplanètes sur la carte principale (blanc)
    Color discovered = new Color(1f, 1f, 1f, 1f);
    // couleur des noms des exoplanètes lorsqu'elles sont validées dans la scène finale (vert)
    Color validated = new Color(0f, 0.8f, 0.2f, 1f);

    // listes des différents sprites permettant d'afficher les noms des exoplanètes sur la scène principale
    // on crée des compteurs pour gérer le temps qu'il faut rester sur les exoplanètes
    public SpriteRenderer trappist_planet_1e_name;
    private int count_trappist_planet = 0;
    public SpriteRenderer wasp_planet_12b_name;
    private int count_wasp_planet = 0;
    public SpriteRenderer sweeps_planet_11b_name;
    private int count_sweeps_planet = 0;

    // listes des différents sprites permettant d'afficher les noms des exoplanètes sur la scène finale (question finale)
    // on crée des compteurs pour gérer le temps qu'il faut rester sur les exoplanètes (scène de la question finale)
    public SpriteRenderer trappist_planet_name;
    private int count_trappist_answer = 0;
    public SpriteRenderer wasp_planet_name;
    private int count_wasp_answer = 0;
    public SpriteRenderer sweeps_planet_name;
    private int count_sweeps_answer = 0;

    private bool answerChosen = false;

    // Start is called before the first frame update
    void Start()
    {
        // on commence avec uniquement la caméra de la scène principale d'active
        mainCam.enabled = true;
        waspCam.enabled = false;
        sweepsCam.enabled = false;
        trappistCam.enabled = false;
        endWaspCam.enabled = false;
        endSweepsCam.enabled = false;
        endTrappistCam.enabled = false;
        endQuestionCam.enabled = false;

        // permet de gérer les mouvements de la loupe
        cam = loupe.GetComponentInChildren<Camera>();
        SpriteRenderer[] sprites = GetComponentsInChildren<SpriteRenderer>();
        Debug.Log("---- OPACITE 0 -----");
        print(loupe.transform.eulerAngles.y);

        // Les nomns des planètes sont invisibles tant qu'elles ne sont pas découvertes (alpha = 0)
        sweeps_planet_11b_name.color = new Color(0f, 0f, 0f, 0f);
        trappist_planet_1e_name.color = new Color(0f, 0f, 0f, 0f);
        wasp_planet_12b_name.color = new Color(0f, 0f, 0f, 0f);

        // initialisation du zoom
        cam.fieldOfView = 6;
    }

    // Update is called once per frame
    void Update()
    {
        // fonction permettant de gérer les interactions en fonction de la position de la caméra
        zoomPlanet();
        // fonction permettant de choisir la réponse à la question finale
        chooseAnswer();
        // permet de contrôler le zoom de la caméra
        boundFOV(cam, 9, 70);
    }

    /*
     * zoomPlanet permet de gérer les changements de caméra lorsque la position de la caméra active atteint certaines zones
    */
    private void zoomPlanet()
    {
        mainCam.enabled = true;
        // si le zoom est activé, il faut être assez zoomé pour découvrir les exoplanètes
        if (cam.fieldOfView < 10)
            {
                //Trappist
                if (loupe.transform.eulerAngles.x > 0 && loupe.transform.eulerAngles.x < 2 && loupe.transform.eulerAngles.y > 184 && loupe.transform.eulerAngles.y < 186)
                {
                    // Il faut que la caméra garde la position pendant un instant pour la découvrir
                    // on utilise pour cela un compteur que sera incrémenté à chaque frame si la caméra a la bonne position
                    count_trappist_planet = count_trappist_planet + 1;

                    // on peut alors afficher le nom de l'exoplanète
                    if (count_trappist_planet == 15)
                    {
                        trappist_planet_1e_name.color = discovered;
                    }
                    // et enfin changer de caméra pour afficher les informations sur l'exoplanète
                    if (count_trappist_planet == 100)
                    {
                        mainCam.enabled = false;
                        trappistCam.fieldOfView = 60;
                        trappistCam.enabled = true;
                    }
                }

                // si la caméra quitte la position, on remet le compteur à zéro et on s'assure que la caméra activée soit la bonne
                else
                {
                    mainCam.enabled = true;
                    count_trappist_planet = 0;
                }

                //Sweeps
                if (loupe.transform.eulerAngles.x > 353 && loupe.transform.eulerAngles.x < 355 && loupe.transform.eulerAngles.y > 179 && loupe.transform.eulerAngles.y < 181)
                {
                    // Il faut que la caméra garde la position pendant un instant pour la découvrir
                    // on utilise pour cela un compteur que sera incrémenté à chaque frame si la caméra a la bonne position
                    count_sweeps_planet = count_sweeps_planet + 1;

                    // on peut alors afficher le nom de l'exoplanète
                    if (count_sweeps_planet == 15)
                    {
                        sweeps_planet_11b_name.color = discovered;
                    }
                    // et enfin changer de caméra pour afficher les informations sur l'exoplanète
                    if (count_sweeps_planet == 100)
                    {
                        mainCam.enabled = false;
                        sweepsCam.fieldOfView = 60;
                        sweepsCam.enabled = true;
                    }
                }
                // si la caméra quitte la position, on remet le compteur à zéro et on s'assure que la caméra activée soit la bonne
                else
                {
                    mainCam.enabled = true;
                    count_sweeps_planet = 0;
                }


                //Wasp
                if (loupe.transform.eulerAngles.x > 6.5 && loupe.transform.eulerAngles.x < 8.5 && loupe.transform.eulerAngles.y > 175 && loupe.transform.eulerAngles.y < 177)
                {
                    // Il faut que la caméra garde la position pendant un instant pour la découvrir
                    // on utilise pour cela un compteur que sera incrémenté à chaque frame si la caméra a la bonne position
                    count_wasp_planet = count_wasp_planet + 1;

                    // on peut alors afficher le nom de l'exoplanète
                    if (count_wasp_planet == 15)
                    {
                        wasp_planet_12b_name.color = discovered;
                    }
                    // et enfin changer de caméra pour afficher les informations sur l'exoplanète
                    if (count_wasp_planet == 100)
                    {
                        mainCam.enabled = false;
                        waspCam.fieldOfView = 60;
                        waspCam.enabled = true;
                    }
                }
                // si la caméra quitte la position, on remet le compteur à zéro et on s'assure que la caméra activée soit la bonne
                else
                {
                    mainCam.enabled = true;
                    count_wasp_planet = 0;
                }


            }
            // si le zoom est activé et n'est pas assez important, aucune exoplanète ne sera affichée
            else
            {
                count_trappist_planet = 0;
                count_sweeps_planet = 0;
                count_wasp_planet = 0;
            }
    }


    /*
     * chooseAnswer permet de gérer la position de la caméra lors de la question de fin
     * change la caméra en fonction de la réponse choisie
    */
    private void chooseAnswer()
    {
        endQuestionCam.fieldOfView = 60;
        // tant qu'aunce réponse n'a été choisie
        if (!answerChosen)
        {
            if (endQuestionCam.enabled == true)
            {
                //ANSWER TRAPPIST
                if (endQuestionCam.transform.eulerAngles.x > 348 && endQuestionCam.transform.eulerAngles.x < 360 && endQuestionCam.transform.eulerAngles.y > 185 && endQuestionCam.transform.eulerAngles.y < 200)
                {
                    // compteur permettant de choisir la réponse à la question
                    count_trappist_answer = count_trappist_answer + 1;

                    // on change la couleur du nom de l'exoplanète pour montrer qu'elle est sélectionnée
                    if (count_trappist_answer == 5)
                    {
                        trappist_planet_name.color = validated;
                    }
                    // on change la caméra pour afficher la scène de fin
                    if (count_trappist_answer == 100)
                    {
                        endQuestionCam.enabled = false;
                        endTrappistCam.fieldOfView = 60;
                        endTrappistCam.enabled = true;
                        answerChosen = true;
                    }
                }
                // si la caméra sort de l'intervalle de détection, on remet le compteur à zéro
                else
                {
                    trappist_planet_name.color = discovered;
                    count_trappist_answer = 0;
                }


                //ANSWER SWEEPS
                if (endQuestionCam.transform.eulerAngles.x > 348 && endQuestionCam.transform.eulerAngles.x < 360 && endQuestionCam.transform.eulerAngles.y > 160 && endQuestionCam.transform.eulerAngles.y < 175)
                {
                    // compteur permettant de choisir la réponse à la question
                    count_sweeps_answer = count_sweeps_answer + 1;

                    // on change la couleur du nom de l'exoplanète pour montrer qu'elle est sélectionnée
                    if (count_sweeps_answer == 5)
                    {
                        sweeps_planet_name.color = validated;
                    }
                    // on change la caméra pour afficher la scène de fin
                    if (count_sweeps_answer == 100)
                    {
                        endQuestionCam.enabled = false;
                        endSweepsCam.fieldOfView = 60;
                        endSweepsCam.enabled = true;
                        answerChosen = true;
                    }
                }
                // si la caméra sort de l'intervalle de détection, on remet le compteur à zéro
                else
                {
                    sweeps_planet_name.color = discovered;
                    count_sweeps_answer = 0;
                }

                //ANSWER WASP
                if (endQuestionCam.transform.eulerAngles.x > 5 && endQuestionCam.transform.eulerAngles.x < 20 && endQuestionCam.transform.eulerAngles.y > 170 && endQuestionCam.transform.eulerAngles.y < 185)
                {
                    // compteur permettant de choisir la réponse à la question
                    count_wasp_answer = count_wasp_answer + 1;

                    // on change la couleur du nom de l'exoplanète pour montrer qu'elle est sélectionnée
                    if (count_wasp_answer == 5)
                    {
                        wasp_planet_name.color = validated;
                    }
                    // on change la caméra pour afficher la scène de fin
                    if (count_wasp_answer == 100)
                    {
                        endQuestionCam.enabled = false;
                        endWaspCam.fieldOfView = 60;
                        endWaspCam.enabled = true;
                        answerChosen = true;
                    }
                }
                // si la caméra sort de l'intervalle de détection, on remet le compteur à zéro
                else
                {
                    wasp_planet_name.color = discovered;
                    count_wasp_answer = 0;
                }
            }
        }
    }



    private IEnumerator wait2Seconds()
    {
        yield return new WaitForSeconds(10.0f);    //Wait one frame
    }

    // permet de garder le zoom de la caméra dans un certain interval
    private void boundFOV(Camera cam, int min, int max)
    {
        if (cam.fieldOfView < min)
        {
            cam.fieldOfView = min;
        }
        else if (cam.fieldOfView > max)
        {
            cam.fieldOfView = max;
        }
    }
}
