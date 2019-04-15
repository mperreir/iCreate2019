using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class StartGame : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(Time());
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    IEnumerator Time()
    {
        yield return new WaitForSeconds(8);
        SceneManager.LoadScene("Scene - Main");
    }
}
