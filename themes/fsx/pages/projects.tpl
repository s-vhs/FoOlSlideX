<nav class="flex px-2 py-1 text-gray-700 bg-gray-50 dark:bg-gray-800 mb-4" aria-label="Breadcrumb">
    <ol class="inline-flex items-center space-x-1 md:space-x-2 rtl:space-x-reverse">
        <li>
            <div class="flex items-center">
                <a href="{$config.url}"
                    class="inline-flex items-center text-sm font-medium text-gray-700 hover:text-blue-600 dark:text-gray-400 dark:hover:text-white">{$config.title}</a>
            </div>
        </li>
        <li>
            <div class="flex items-center">
                <span class="text-gray-400 cursor-default">»</span>
                <a href="{$config.url}projects"
                    class="ms-1 text-sm font-medium text-gray-700 hover:text-blue-600 md:ms-2 dark:text-gray-400 dark:hover:text-white">Projects</a>
            </div>
        </li>
        <li>
            <div class="flex items-center">
                <span class="text-gray-400 cursor-default">»</span>
                <span class="ms-1 text-sm font-medium text-gray-500 md:ms-2 dark:text-gray-400">Page {$page}</span>
            </div>
        </li>
    </ol>
</nav>

<div class="px-2 xl:px-0">
    <p class="text-2xl">
        Projects - Page {$page}
        {if $logged && $user.level <= 14}
            <a type="button" href="{$config.url}publisher/validate_custom/title/create"
                class="text-white bg-blue-700 hover:bg-blue-800 font-medium text-sm p-1 dark:bg-blue-600 dark:hover:bg-blue-700">Create
                Title</a>
        {/if}
    </p>
    <div class="grid grid-cols-6 gap-2 my-2" id="titlesDiv">
        <div class="col-span-6" id="loadingTagsText">Loading titles... <a href="#"
                class="text-blue-500 hover:underline dark:text-blue-600" onclick="getTitles()">Try again!</a></div>
    </div>
    <nav class="my-2">
        <ul class="inline-flex -space-x-px text-sm" id="paginationDiv">
        </ul>
    </nav>
</div>

<script>
    function getTitles() {
        $.ajax({
            url: "{$config.url}api/titles/{$page}",
            method: 'GET',
            dataType: 'json',
            success: function(data) {
                // Work with the JSON data here
                console.log('Data from API:', data);

                // Check if the data is an object
                if (typeof data !== 'object') {
                    console.error('Data is not in the expected format.');
                    return;
                }

                // Create a container div for each array
                $("#titlesDiv").empty();
                const containerDiv = document.getElementById("titlesDiv");
                if (containerDiv) {
                    // Create checkboxes for each item in the array
                    data.msg.forEach(item => {
                        const card = createDynamicCard(item);
                        containerDiv.appendChild(card);
                    });
                }

                $("#paginationDiv").empty();
                const paginationDiv = document.getElementById("paginationDiv");
                if (paginationDiv) {
                    for (let p = 1; p <= data.totalpages; p++) {
                        console.log("Pagination: " + p);
                        const pagination = createPaginationElement(p);
                        paginationDiv.appendChild(pagination);
                    }
                }

                $("#loadingTagsText").addClass("hidden");
            },
            error: function(xhr, status, error) {
                console.error('There was a problem fetching data:', error);
            }
        });
    }

    getTitles();

    function createPaginationElement(p) {
        const pagiDiv = document.createElement("li");
        const pagiLink = document.createElement("a");

        if (p == {$page}) {
        pagiLink.className =
            "flex items-center justify-center px-3 h-8 border border-gray-300 dark:border-gray-700 text-blue-600 dark:text-white dark:bg-gray-700 bg-blue-50 hover:bg-blue-100 hover:text-blue-700";
    } else {
        pagiLink.className =
            "flex items-center justify-center px-3 h-8 border border-gray-300 dark:border-gray-700 leading-tight text-gray-500 bg-white hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white";
        pagiLink.href = "{$config.url}projects/" + p;
    }
    pagiLink.textContent = p;

    pagiDiv.appendChild(pagiLink);
    return (pagiDiv);
    }

    function createDynamicCard(item) {
        const cardDiv = document.createElement('div');
        cardDiv.className = 'col-span-1 relative aspect-[5/7]';

        const link = document.createElement('a');
        link.href = `{$config.url}project/` + item.uid + `/info`;
        link.className = 'block h-full relative';

        const imageDiv = document.createElement('div');
        imageDiv.className = 'h-full w-full overflow-hidden';

        const img = document.createElement('img');
        if (item.cover) {
            img.src = `{$config.url}api/image/` + item.cover + `/title`;
        } else {
            img.src = `{$config.url}api/image/no-cover.jpg/error`;
        }
        img.alt = 'Cover Image';
        img.className = 'w-full h-full object-cover';

        imageDiv.appendChild(img);

        let statusClasses = '';
        let statusText = '';

        switch (item.status.upload) {
            case 1:
                statusClasses = 'text-white bg-blue-500 dark:text-blue-800 dark:bg-blue-200';
                statusText = 'Planned';
                break;
            case 2:
                statusClasses = 'text-white bg-orange-500 dark:text-orange-800 dark:bg-orange-200';
                statusText = 'Ongoing';
                break;
            case 3:
                statusClasses = "text-gray-600 bg-gray-200 dark:text-gray-800 dark:bg-gray-200";
                statusText = "Hiatus";
                break;
            case 4:
                statusClasses = "text-white bg-green-500 dark:text-green-800 dark:bg-green-200";
                statusText = "Completed";
                break;
            default:
                statusClasses = 'text-white bg-red-500 dark:text-red-800 dark:bg-red-200';
                statusText = 'Cancelled';
                break;
        }

        const statusSpan = document.createElement('span');
        statusSpan.className = `absolute top-0 left-0 px-2 py-1 ` + statusClasses +
            ` text-sm bg-opacity-75 dark:bg-opacity-90`;
        statusSpan.textContent = statusText;

        const titleSpan = document.createElement('span');
        titleSpan.className =
            'absolute bottom-0 left-0 right-0 px-2 py-1 text-blue-500 hover:underline dark:text-blue-600 bg-white bg-opacity-75 dark:bg-black dark:bg-opacity-75';
        titleSpan.textContent = item.title;

        link.appendChild(imageDiv);
        link.appendChild(statusSpan);
        link.appendChild(titleSpan);
        cardDiv.appendChild(link);

        return cardDiv;
    }
</script>

<nav class="flex px-2 py-1 text-gray-700 bg-gray-50 dark:bg-gray-800 my-4" aria-label="Breadcrumb">
    <ol class="inline-flex items-center space-x-1 md:space-x-2 rtl:space-x-reverse">
        <li>
            <div class="flex items-center">
                <a href="{$config.url}"
                    class="inline-flex items-center text-sm font-medium text-gray-700 hover:text-blue-600 dark:text-gray-400 dark:hover:text-white">{$config.title}</a>
            </div>
        </li>
        <li>
            <div class="flex items-center">
                <span class="text-gray-400 cursor-default">»</span>
                <a href="{$config.url}projects"
                    class="ms-1 text-sm font-medium text-gray-700 hover:text-blue-600 md:ms-2 dark:text-gray-400 dark:hover:text-white">Projects</a>
            </div>
        </li>
        <li>
            <div class="flex items-center">
                <span class="text-gray-400 cursor-default">»</span>
                <span class="ms-1 text-sm font-medium text-gray-500 md:ms-2 dark:text-gray-400">Page {$page}</span>
            </div>
        </li>
    </ol>
</nav>