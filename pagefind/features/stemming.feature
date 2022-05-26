Feature: Word Stemming
    Background:
        Given I have a "public/index.html" file with the content:
            """
            <ul>
                <li data-result>
            </ul>
            """

    Scenario: Searching for a word will match against the stem of that word
        Given I have a "public/cat/index.html" file with the content:
            """
            <body>
                <h1>the cat is meowing</h1>
            </body>
            """
        When I run my program
        Then I should see "Running Pagefind" in stdout
        Then I should see the file "public/_pagefind/pagefind.js"
        When I serve the "public" directory
        When I load "/"
        When I evaluate:
            """
            async function() {
                let pagefind = await import("/_pagefind/pagefind.js");

                let results = await pagefind.search("meowed");

                let data = await results[0].data();
                document.querySelector('[data-result]').innerText = data.url;
            }
            """
        Then There should be no logs
        Then The selector "[data-result]" should contain "/cat/"

    Scenario: Search is case independent
        Given I have a "public/cat/index.html" file with the content:
            """
            <body>
                <h1>the cat is Meowing</h1>
            </body>
            """
        When I run my program
        Then I should see "Running Pagefind" in stdout
        Then I should see the file "public/_pagefind/pagefind.js"
        When I serve the "public" directory
        When I load "/"
        When I evaluate:
            """
            async function() {
                let pagefind = await import("/_pagefind/pagefind.js");

                let results = await pagefind.search("meOWings");

                let data = await results[0].data();
                document.querySelector('[data-result]').innerText = data.url;
            }
            """
        Then There should be no logs
        Then The selector "[data-result]" should contain "/cat/"

