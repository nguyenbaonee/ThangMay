<script setup>
import { computed, onMounted, ref } from 'vue'
import { PhoneCall } from 'lucide-vue-next'
import companyContactApi from '@/api/companyContactApi'

const contacts = ref([])

const getVal = (key) => contacts.value.find((item) => item.configKey === key)?.configValue || ''

const hotlineLabel = computed(() => getVal('hotline'))
const hotlineHref = computed(() => `tel:${String(hotlineLabel.value || '').replace(/\s+/g, '')}`)
const zaloHref = computed(() => getVal('zalo_url'))

const fetchContacts = async () => {
  try {
    const res = await companyContactApi.getPublic()
    contacts.value = res.data || []
  } catch (error) {
    console.error('Error fetching floating contact info:', error)
  }
}

onMounted(fetchContacts)
</script>

<template>
  <div class="floating-contact-buttons">
    <a :href="zaloHref" target="_blank" rel="noreferrer" class="floating-btn zalo-btn" aria-label="Chat Zalo">
      <img src="/images.png" alt="Zalo" />
    </a>

    <a :href="hotlineHref" class="floating-btn phone-btn" aria-label="Gọi hotline">
      <span class="phone-number">{{ hotlineLabel }}</span>
      <span class="phone-icon-wrap">
        <PhoneCall :size="20" />
      </span>
    </a>
  </div>
</template>

<style scoped>
.floating-contact-buttons {
  position: fixed;
  right: 20px;
  bottom: 88px;
  z-index: 1200;
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 12px;
}

.floating-btn {
  display: inline-flex;
  align-items: center;
  text-decoration: none;
  box-shadow: 0 14px 30px rgba(15, 23, 42, 0.18);
}

.zalo-btn {
  width: 56px;
  height: 56px;
  justify-content: center;
  border-radius: 999px;
  background: #fff;
}

.zalo-btn img {
  width: 34px;
  height: 34px;
  object-fit: contain;
}

.phone-btn {
  border-radius: 999px;
  overflow: hidden;
  background: linear-gradient(135deg, #5cc742, #389e2c);
  color: #fff;
}

.phone-number {
  padding: 0 18px 0 20px;
  font-size: 1.05rem;
  font-weight: 700;
  line-height: 56px;
  white-space: nowrap;
}

.phone-icon-wrap {
  width: 56px;
  height: 56px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.18);
}

@media (max-width: 768px) {
  .floating-contact-buttons {
    right: 14px;
    bottom: 76px;
    gap: 10px;
  }

  .zalo-btn,
  .phone-icon-wrap {
    width: 50px;
    height: 50px;
  }

  .phone-number {
    font-size: 0.95rem;
    line-height: 50px;
    padding: 0 14px 0 16px;
  }
}

@media (max-width: 480px) {
  .phone-number {
    display: none;
  }

  .phone-btn {
    width: 50px;
    height: 50px;
    border-radius: 999px;
    justify-content: center;
  }
}
</style>
