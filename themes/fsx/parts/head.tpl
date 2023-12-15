<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>{$pageTitle}</title>
    <link href="{$config.url}fsx/css" rel="stylesheet" data-instant-track>
    <script src="{$config.url}fsx/jquery" data-instant-track></script>

    <style data-instant-track>
        @font-face {
            font-family: 'Courier Prime';
            font-style: normal;
            font-weight: normal;
            src: url("{$config.url}fsx/font?name=CourierPrime-Regular&path=Courier_Prime") format('truetype');
        }

        @font-face {
            font-family: 'Courier Prime';
            font-style: italic;
            font-weight: normal;
            src: url("{$config.url}fsx/font?name=CourierPrime-Italic&path=Courier_Prime") format('truetype');
        }

        @font-face {
            font-family: 'Courier Prime';
            font-style: normal;
            font-weight: bold;
            src: url("{$config.url}fsx/font?name=CourierPrime-Bold&path=Courier_Prime") format('truetype');
        }

        @font-face {
            font-family: 'Courier Prime';
            font-style: italic;
            font-weight: bold;
            src: url("{$config.url}fsx/font?name=CourierPrime-Bolditalic&path=Courier_Prime") format('truetype');
        }


        @font-face {
            font-family: 'PT Serif';
            font-style: normal;
            font-weight: normal;
            src: url("{$config.url}fsx/font?name=PTSerif-Regular&path=PT_Serif") format('truetype');
        }

        @font-face {
            font-family: 'PT Serif';
            font-style: italic;
            font-weight: normal;
            src: url("{$config.url}fsx/font?name=PTSerif-Italic&path=PT_Serif") format('truetype');
        }

        @font-face {
            font-family: 'PT Serif';
            font-style: normal;
            font-weight: bold;
            src: url("{$config.url}fsx/font?name=PTSerif-Bold&path=PT_Serif") format('truetype');
        }

        @font-face {
            font-family: 'PT Serif';
            font-style: italic;
            font-weight: bold;
            src: url("{$config.url}fsx/font?name=PTSerif-Bolditalic&path=PT_Serif") format('truetype');
        }

        * {
            font-family: 'Courier Prime', monospace;
            font-family: 'PT Serif', serif;
        }
    </style>

    <script data-instant-track>
        // On page load or when changing themes, best to add inline in `head` to avoid FOUC
        if (localStorage.getItem('color-theme') === 'dark' || (!('color-theme' in localStorage) && window.matchMedia(
                '(prefers-color-scheme: dark)').matches)) {
            document.documentElement.classList.add('dark');
        } else {
            document.documentElement.classList.remove('dark')
        }
    </script>
</head>

<body>