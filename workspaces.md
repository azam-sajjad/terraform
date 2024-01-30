Terraform Cloud Repository Management Patterns

Two Approaches:

1) Mono-Repo
    Mono-Repo Patterns:


        - single workspace per repository directory
        
                App
                |
                ---Environments---------------Modules
                        |                       |
                        |__Dev                  |__Compute
                        |__Test                 |__Network
                        |__Prod
            * this is for organizations with significant differences per environments
            * and where short-lived branches are frequesntly merged into main branch
            * each workspace is aligned to a different environment directory
            * each workspace listens to changes on main branch in specied directory
            - Pros
            * all states in their respective environment directory
            * single repo contains all infrastructure
            * simple RBAC rules
            - Cons
            * Manual Promotion between stages


        - single workspace per repository branch 
                App
                |
                |
                Dev Branch---------------------------Test Branch
                |
                |__main.tf                        
                |__variables.tf
                |__Modules
                        |__Compute
                        |__Network                        
                                 
                        
                
2) Multi-Repo

     ____REPO 1______________
    |    APP 1              |-------Network v1.0-------Network Repo
    |    |                  |
    |    |_Dev              |
    |    |_Test             |-------
    |    |_Prod             |       |
    |_______________________|       |
                                    |__Security v1.0---Security Repo

                                     __Security v2.0---Security Repo
     ____REPO 2______________       |
    |    APP 2              |       |
    |    |                  |--------
    |    |_Dev              |
    |    |_Test             |
    |    |_Prod             |--------Data v1.0---------Data Repo
    |_______________________|

    * for large teams that collaborates on complex infrastructure systems
    * separate repos for business domain, application domain, team
    * modules, applications within their own repositories