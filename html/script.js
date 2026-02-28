let currentMenu = null;
let currentMenuId = null;
let menuHistory = [];
let canClose = true;

window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.type) {
        case 'SHOW_MENU':
            showMenu(data.menu, data.menuId);
            break;
        case 'HIDE_MENU':
            hideMenu();
            break;
    }
});

function showMenu(menu, menuId, addToHistory = true) {
    if (!menu) return;
    
    if (addToHistory && currentMenu) {
        menuHistory.push({
            menu: currentMenu,
            menuId: currentMenuId
        });
    }
    
    currentMenu = menu;
    currentMenuId = menuId;
    canClose = menu.canClose !== false;
    
    renderMenu(menu);
    document.getElementById('context-menu').style.display = 'block';
}

function hideMenu() {
    document.getElementById('context-menu').style.display = 'none';
    currentMenu = null;
    currentMenuId = null;
    menuHistory = [];
    canClose = true;
}

function goBack() {
    if (menuHistory.length > 0) {
        const previous = menuHistory.pop();
        
        if (currentMenuId) {
            fetch(`https://${GetParentResourceName()}/menuEvent`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    event: 'onBack'
                })
            });
        }
        
        showMenu(previous.menu, previous.menuId, false);
    }
}

function renderMenu(menu) {
    const container = document.getElementById('context-menu');
    container.className = menu.position || 'top-right';
    
    let html = `
        <div class="menu-header">
            ${menu.menu ? '<div class="back-button" onclick="goBack()"><i class="fas fa-arrow-left"></i></div>' : ''}
            <div class="menu-title">${menu.title}</div>
        </div>
        <div class="menu-options">
    `;
    
    menu.options.forEach((option, index) => {
        html += renderOption(option, index);
    });
    
    html += '</div>';
    container.innerHTML = html;
}

function renderOption(option, index) {
    const classes = ['menu-option'];
    if (option.disabled) classes.push('disabled');
    if (option.readOnly) classes.push('readonly');
    
    let html = `<div class="${classes.join(' ')}" data-option-index="${index}" data-option='${JSON.stringify(option).replace(/'/g, "&apos;")}'>`;
    
    html += '<div class="option-header">';
    
    if (option.icon) {
        html += `<div class="option-icon">`;
        if (option.icon.startsWith('http')) {
            html += `<img src="${option.icon}" style="width: 24px; height: 24px; border-radius: 4px;">`;
        } else {
            let iconHtml = `<i class="fas fa-${option.icon}"`;
            if (option.iconAnimation) {
                iconHtml += ` class="fa-${option.iconAnimation}"`;
            }
            if (option.iconColor) {
                iconHtml += ` style="color: ${option.iconColor};"`;
            }
            iconHtml += `></i>`;
            html += iconHtml;
        }
        html += '</div>';
    }
    
    html += '<div class="option-title-container">';
    html += `<div class="option-title">${option.title || 'Button'}</div>`;
    if (option.menu || option.arrow) {
        html += '<div class="option-arrow"><i class="fas fa-chevron-right"></i></div>';
    }
    html += '</div>';
    html += '</div>';
    
    if (option.description) {
        html += `<div class="option-description">${option.description}</div>`;
    }
    
    if (option.image) {
        html += `<div class="option-image"><img src="${option.image}" alt=""></div>`;
    }
    
    if (option.progress) {
        const colorScheme = option.colorScheme || 'green';
        html += `<div class="option-progress"><div class="progress-bar ${colorScheme}" style="width: ${option.progress}%;"></div></div>`;
    }
    
    if (option.metadata && option.metadata.length > 0) {
        html += '<div class="metadata-container">';
        option.metadata.forEach(item => {
            html += '<div class="metadata-item">';
            html += `<span class="metadata-label">${item.label}:</span>`;
            html += `<span class="metadata-value">${item.value}</span>`;
            if (item.progress) {
                const colorScheme = item.colorScheme || 'green';
                html += `<div class="metadata-progress"><div class="progress-bar ${colorScheme}" style="width: ${item.progress}%;"></div></div>`;
            }
            html += '</div>';
        });
        html += '</div>';
    }
    
    html += '</div>';
    return html;
}

document.addEventListener('click', function(e) {
    const option = e.target.closest('.menu-option');
    if (!option) return;
    
    const optionIndex = option.dataset.optionIndex;
    const optionData = JSON.parse(option.dataset.option);
    
    if (optionData.disabled || optionData.readOnly) return;
    
    if (optionData.menu) {
        fetch(`https://${GetParentResourceName()}/navigateToMenu`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                menuId: optionData.menu
            })
        });
    } else {
        fetch(`https://${GetParentResourceName()}/selectOption`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                menuId: currentMenuId,
                optionIndex: parseInt(optionIndex),
                optionData: optionData
            })
        });
    }
});